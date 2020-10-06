from bokeh.layouts import column
from bokeh.layouts import widgetbox
from bokeh.models import CustomJS, ColumnDataSource, Slider, TextInput
from bokeh.plotting import Figure, output_file, show, save
import geopandas as gp
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from bokeh.plotting import figure, output_file, show
from bokeh.tile_providers import get_provider, Vendors
from bokeh.models import ColumnDataSource, CategoricalColorMapper
from bokeh.models import HoverTool
from bokeh.plotting import figure, output_file, show
from bokeh.io import output_notebook, push_notebook
from bokeh.io import curdoc
from bokeh.layouts import column, row

## Functions
def getXYCoords(geometry, coord_type):
    """ Returns either x or y coordinates from  geometry coordinate sequence. Used with LineString and Polygon geometries."""
    if coord_type == 'x':
        return geometry.coords.xy[0]
    elif coord_type == 'y':
        return geometry.coords.xy[1]

def getPolyCoords(geometry, coord_type):
    """ Returns Coordinates of Polygon using the Exterior of the Polygon."""
    ext = geometry.exterior
    return getXYCoords(ext, coord_type)

def getLineCoords(geometry, coord_type):
    """ Returns Coordinates of Linestring object."""
    return getXYCoords(geometry, coord_type)

def getPointCoords(geometry, coord_type):
    """ Returns Coordinates of Point object."""
    if coord_type == 'x':
        return geometry.x
    elif coord_type == 'y':
        return geometry.y

def multiGeomHandler(multi_geometry, coord_type, geom_type):
    """
    Function for handling multi-geometries. Can be MultiPoint, MultiLineString or MultiPolygon.
    Returns a list of coordinates where all parts of Multi-geometries are merged into a single list.
    Individual geometries are separated with np.nan which is how Bokeh wants them.
    # Bokeh documentation regarding the Multi-geometry issues can be found here (it is an open issue)
    # https://github.com/bokeh/bokeh/issues/2321
    """

    for i, part in enumerate(multi_geometry):
        # On the first part of the Multi-geometry initialize the coord_array (np.array)
        if i == 0:
            if geom_type == "MultiPoint":
                coord_arrays = np.append(getPointCoords(part, coord_type), np.nan)
            elif geom_type == "MultiLineString":
                coord_arrays = np.append(getLineCoords(part, coord_type), np.nan)
            elif geom_type == "MultiPolygon":
                coord_arrays = np.append(getPolyCoords(part, coord_type), np.nan)
        else:
            if geom_type == "MultiPoint":
                coord_arrays = np.concatenate([coord_arrays, np.append(getPointCoords(part, coord_type), np.nan)])
            elif geom_type == "MultiLineString":
                coord_arrays = np.concatenate([coord_arrays, np.append(getLineCoords(part, coord_type), np.nan)])
            elif geom_type == "MultiPolygon":
                coord_arrays = np.concatenate([coord_arrays, np.append(getPolyCoords(part, coord_type), np.nan)])

    # Return the coordinates
    return coord_arrays


def getCoords(row, geom_col, coord_type):
    """
    Returns coordinates ('x' or 'y') of a geometry (Point, LineString or Polygon) as a list (if geometry is LineString or Polygon).
    Can handle also MultiGeometries.
    """
    # Get geometry
    geom = row[geom_col]

    # Check the geometry type
    gtype = geom.geom_type

    # "Normal" geometries
    # -------------------

    if gtype == "Point":
        return getPointCoords(geom, coord_type)
    elif gtype == "LineString":
        return list( getLineCoords(geom, coord_type) )
    elif gtype == "Polygon":
        return list( getPolyCoords(geom, coord_type) )

    # Multi geometries
    # ----------------

    else:
        return list( multiGeomHandler(geom, coord_type, gtype) )

## data processing and setup
dataset = pd.read_csv("/Volumes/harddisk/kiran usb_backup/project_job/dataset_mod/location_all.csv")
d = dataset[dataset.MLVA.eq("3-9-7-13-523")]
d.date = pd.to_datetime(d.date)


common_seq_prj = gp.GeoDataFrame(d,
                               crs= {'init': 'epsg:4283'},
                               geometry=gp.points_from_xy(d.X, d.Y))
common_seq_prj = common_seq_prj.to_crs(epsg=3857)
common_seq_prj=common_seq_prj.sort_values('date')
common_seq_prj['month'] = pd.Series(common_seq_prj.date.dt.month, index = common_seq_prj.index)
common_seq_prj['year'] = pd.Series(common_seq_prj.date.dt.year, index = common_seq_prj.index)
common_seq_prj['geom_x'] = common_seq_prj.apply(getCoords, geom_col="geometry", coord_type="x", axis=1)
common_seq_prj['geom_y'] = common_seq_prj.apply(getCoords, geom_col="geometry", coord_type="y", axis=1)
common_seq_prj.set_index(['year', 'month'], inplace=True)

source = ColumnDataSource(dict(
    lat = common_seq_prj['geom_x'],
    lng = common_seq_prj['geom_y'] ,
    mlva = common_seq_prj['MLVA'],
    date = common_seq_prj['date']
)
)

#Bokeh plot setup
tile_provider = get_provider(Vendors.STAMEN_TONER)
TOOLTIPS = [
   #('MLVA','@mlva'),
    ('date','@date')
]

# range bounds supplied in web mercator coordinates
p = figure(x_range=(15500000, 17200000), y_range=(-4500000, -3500000),
           x_axis_type="mercator", y_axis_type="mercator",
           tooltips=TOOLTIPS
          )
p.add_tile(tile_provider)
p.circle("lat","lng", size = 10,
         source = source,
         #fill_color = {'field':'color', 'transform': color_mapper},
         fill_alpha=1,
         line_color=None
        )

# Widget slider setup
year = Slider(title="year", value=2010.0, start=2008.0, end=2016.0, step= 1.0)
month = Slider(title="month", value=4.0, start=1.0, end=12.0, step= 1.0)
#
# #callback
def update_data2(attrname, old, new):
    y = year.value
    m = month.value

    source.data = dict(
    lng=common_seq_prj.loc[y].loc[m].geom_y,
    lat= common_seq_prj.loc[y].loc[m].geom_x,
    MLVA = common_seq_prj.loc[y].loc[m].MLVA,
    date =  common_seq_prj.loc[y].loc[m].date.dt.day
    )
#
#
for w in [year, month]:
    w.on_change('value', update_data2)
#
# # Set up layouts and add to document
inputs = column(year, month)

curdoc().add_root(row(inputs, p, width=1500))
curdoc().title = "Most commonly occuring MLVA strain"
