---
layout: post
title: "Lesson 00: Intro to Raster Data in R"
date:   2015-10-29
authors: [Kristina Riemer, Zack Brym, Jason Williams, Jeff Hollister,  Mike Smorul, Leah Wasser]
contributors: [Megan A. Jones]
dateCreated: 2015-10-23
lastModified: 2015-12-14
packagesLibraries: [raster, rgdal]
category:  
tags: [raster-ts-wrksp, raster]
mainTag: raster-ts-wrksp
description: "This lesson review the fundamental principles, libraries and 
metadata / raster attributes that you need to be familiar with in order to 
successfully work with raster data in R."
code1: SR00-Raster-Structure.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Introduction-to-Raster-Data-In-R
comments: false
---

{% include _toc.html %}

##About
In this lesson, we will cover the basics of raster data and how to how to open, 
plot and explore raster data properties in `R`.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives

After completing this activity, you will:

* Understand what a raster dataset is and its fundamental attributes.
* Know how to explore raster attributes in `R`.
* Be able to import rasters into `R` using the `raster` library.
* Be able to quickly plot a raster file in `R`.
* Understand the difference between single- and mult-band rasters.

###Challenge Code
Throughout the lesson we have Challenges that reinforce learned skills. Possible
solutions to the challenges are not posted on this page, however, the code for 
each challenge is in the `R` code that can be downloaded for this lesson (see 
footer on this page).


###Things You'll Need To Complete This Lesson
You will need the most current version of R, and, preferably, RStudio loaded on
your computer to complete this lesson.

####R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`


####Data to Download
Download the raster files teaching dataset:

<a href="https://ndownloader.figshare.com/files/3579867" class="btn btn-success"> Download NEON Airborne Observation Platform Raster Data Teaching Subset</a> 

The LiDAR and imagery data used to create the rasters in this dataset were 
collected over the <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard</a>
and 
<a href="http://www.neoninc.org/science-design/field-sites/san-joaquin-experimental-range" target="_blank" >San Joaquin</a>
field sites and processed at
<a href="http://www.neoninc.org" target="_blank" >NEON </a> 
headquarters. The entire dataset can be accessed by request from the 
<a href="http://www.neoninc.org/data-resources/get-data/airborne-data" target="_blank"> NEON airborne data website.</a>

####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a
refresher on setting the working directory, please view the [Setting A Working Directory In R]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") 
lesson prior to beginning this lesson.

###Raster Lesson Series 
This lesson is a part of a lesson series on raster data in R:

* [Intro to Raster Data in R]({{ site.baseurl}}/R/Introduction-to-Raster-Data-In-R/)
* [Plot Raster Data in R]({{ site.baseurl}}/R/Plot-Rasters-In-R/)
* [Reproject Raster Data in R]({{ site.baseurl}}/R/Reproject-Raster-In-R/)
* [ Raster Calculations in R]({{ site.baseurl}}/R/Raster-Calculations-In-R/)
* [Work With Multi-Band Rasters - Images in R]({{ site.baseurl}}/R/Multi-Band-Rasters-In-R/)
* [Raster Time Series Data in R]({{ site.baseurl}}/R/Raster-Times-Series-Data-In-R/)
* [Plot Raster Time Series Data in R Using RasterVis and LevelPlot]({{ site.baseurl}}/R/Plot-Raster-Times-Series-Data-In-R/)
* [Extract NDVI Summary Values from a Raster Time Series]({{ site.baseurl}}/R/Extract-NDVI-From-Rasters-In-R/)

###Sources of Additional Information

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in R.</a>
* <a href="http://neondataskills.org/R/Raster-Data-In-R/" target="_blank" >  NEON Data Skills: Raster Data in R - The Basics</a>
* <a href="http://neondataskills.org/R/Image-Raster-Data-In-R/" target="_blank" > NEON Data Skills: Image Raster Data in R - An Intro</a>

</div>


#About Raster Data
Raster or "gridded" data are saved on a regular grid which is rendered on a map
as pixels. Each pixel contains a value that represents an area on the Earth's 
surface.

![What Is A Raster Dataset]({{ site.baseurl }}/images/raster_timeseries/raster_concept.png)

#Types of Data Stored as Rasters
Raster data can be continuous or categorical. Continuous rasters can have a 
range of quantitative values. Some examples of continuous rasters include:

1. Precipitation maps.
2. Maps of tree height derived from LiDAR data.
3. Elevation values for a region. 

A map of elevation for Harvard Forest derived from the  <a href="http://www.neoninc.org/science-design/collection-methods/airborne-remote-sensing" target="_blank"> NEON AOP LiDAR sensor</a> 
is below. Notice that elevation is a continuous numeric variable. The legend
represents the continuous range of values in the data from around 300 to 420 meters.




![ ]({{ site.baseurl }}/images/rfigs/SR00-Raster-Structure/elevation-map-1.png) 

Some rasters contain categorical data. Thus each pixel represents a class such
as a landcover class ("forest") rather than a continuous value such as elevation 
or temperature. Some examples of classified maps include:

1. Landcover / landuse maps.
2. Tree height maps classified short, medium, tall trees.
3. Elevation maps classified low, medium and high elevation.

The legend of this map shows the colors representing each discrete class. 

![ ]({{ site.baseurl }}/images/rfigs/SR00-Raster-Structure/classified-elevation-map-1.png) 

###Categorical Landcover Map for the United States 
![US NLCD Map](http://neondataskills.org/images/spatialData/NLCD06_conus_lg.gif)

#What is a GeoTIFF??
Raster data can come in many different formats. In this lesson, we will use the 
geotiff format which has the extension `.tif`. A `.tif` file stores metadata
or attributes about the file as embedded `tif tags`. For instance, your camera
might 
store a tag that describes the make and model of the camera or the date the
photo was taken when it saves a `.tif`. A GeoTIFF is a standard `.tif` image
format with addition spatial (georeferencing) information embedded in the file
as a tag. These tags can include the following raster metadata:

1. A Coordinate Reference System (`CRS`)
2. Spatial Extent
3. `NoData` Values 
4. The `resolution` of the data

In this lesson we will discuss all of these metadata tags.

> More about the  `.tif` format:
> 
> * <a href="https://en.wikipedia.org/wiki/GeoTIFF" target="_blank"> Geotiff on Wikipedia</a>
> * <a href="https://trac.osgeo.org/geotiff/" target="_blank"> OSGEO Tiff documentation</a>

##Raster Data in R

We will begin by opening up a raster dataset in `R` and exploring its metadata.
To open rasters in `R`, we will use the `raster` and `rgdal` packages.


    #load libraries
    library(raster)
    library(rgdal)
    
    #set working directory to ensure R can find the file we wish to import
    #setwd("working-dir-path-here")

##Open a Raster in R
We can use the `raster("path-to-raster-here")` function to open a raster in R. 

NAMES: To improve code readability, file and object names should be make it 
clear what is in the file. The data for this lesson were collected over 
from Harvard Forest so we'll use a naming convention of data_HARV. {: .notice2}


    # Load raster into R
    DSM_HARV <- raster("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")
    
    # View raster structure
    DSM_HARV 

    ## class       : RasterLayer 
    ## dimensions  : 1367, 1697, 2319799  (nrow, ncol, ncell)
    ## resolution  : 1, 1  (x, y)
    ## extent      : 731453, 733150, 4712471, 4713838  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## data source : /Users/mjones01/Documents/data/Spatio_TemporalWorkshop/NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif 
    ## names       : HARV_dsmCrop 
    ## values      : 305.07, 416.07  (min, max)

    #simple plot of the raster
    #note \n in the title forces a line break in the title
    plot(DSM_HARV, 
         main="NEON Digital Surface Model\nHarvard Forest")

![ ]({{ site.baseurl }}/images/rfigs/SR00-Raster-Structure/open-raster-1.png) 

Here is a map showing the elevation of our site in Harvard Forest.  Does this 
top out at just over 400 meters or 400 feet?  Perhaps we need to learn more 
about attributes and metadata!

## Coordinate Reference System
The Coordinate Reference System or `CRS` tells `R` where the raster is located
in geographic space. It also tells `R` what method should be used to "flatten"
or project the raster in geographic space. 

<figure>
    <a href="https://source.opennews.org/media/cache/b9/4f/b94f663c79024f0048ae7b4f88060cb5.jpg">
    <img src="https://source.opennews.org/media/cache/b9/4f/b94f663c79024f0048ae7b4f88060cb5.jpg">
    </a>
    
    <figcaption> Maps of the United States in different projections. Notice the 
    differences in shape associated with each different projection. These 
    differences are a direct result of the calculations used to "flatten" the 
    data onto a 2 dimensional map. Image source: opennews.org</figcaption>
</figure>

##What Makes Spatial Data Line Up On A Map?
There are lots of great resources that describe coordinate reference systems and
projections in greater detail. For the purposes of this activity, what 
is important to understand is that data from the same location but saved in 
different projections **will not line up in any GIS or other program**. Thus 
it's important when working with spatial data in a program like `R` or `Python` 
to identify the coordinate reference system applied to the data and retain it 
throughout the processing and analysing of the data.

Read More: 

* <a href="http://spatialreference.org/ref/epsg/" target="_blank"> A comprehensive
online library of CRS information.</a>
* <a href="http://docs.qgis.org/2.0/en/docs/gentle_gis_introduction/coordinate_reference_systems.html" target="_blank">QGIS Documentation - CRS Overview</a>
* <a href="https://source.opennews.org/en-US/learning/choosing-right-map-projection/" target="_blank">Choosing the Right Map Projection.</a>
* <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf" target="_blank"> NCEAS Overview of CRS in R</a>

###How Map Projections Can Fool the Eye
Check out this short video highlighting how map projections can make continents 
seems proportionally larger or smaller than they actually are!

<iframe width="560" height="315" src="https://www.youtube.com/embed/KUF_Ckv8HbE" frameborder="0" allowfullscreen></iframe>

While we will not go into great depth with respect to understanding Coordinate
Reference Systems in this lesson, it is important to understand that 
if your data are in different CRSs, then they will not line up in `R`. (They may
line up in a GIS interface that knows how to "reproject on the fly" to make
things line up visually. 

We can view just the CRS string associated with our `R` object using the`crs()` 
method. We can assign this string to an `R` object too.


    #view resolution units
    crs(DSM_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #assign crs to an object (class) to use for reprojection and other tasks
    myCRS <- crs(DSM_HARV)
    myCRS

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

From this we can see that our data are in the UTM projection.

<figure>
    <a href="https://en.wikipedia.org/wiki/File:Utm-zones.svg">
    <img src="http://upload.wikimedia.org/wikipedia/en/thumb/5/57/Utm-zones.svg/720px-Utm-zones.svg.png">
    </a>
    
    <figcaption> The UTM zones across the continental United States.  Image source: Chrismurf, wikimedia.org</figcaption>
</figure>

The CRS in this case is in a `PROJ 4` format. This means that the projection
information is strung together as a series of text elements, each of which 
begins with a `+` sign. 

 `+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`

We'll focus on the first few components of the CRS in this lesson.

* `+proj=utm` The projection of the dataset. Our data are in Universal 
Transverse Mercator (UTM).  
* `+zone=18` The UTM projection divides up the world into zones, this element
tells you which zone the data is in. Harvard Forest is in Zone 18.
* `+datum=WGS84` The datum was used to define the center point of the 
projection. Our raster uses the `WGS84` datum.
* `+units=m` This is the horizontal units that the data are in. Our units 
are meters. 

## Resolution
A raster has horizontal (x and y) resolution. This resolution represents the 
area on the ground that each pixel covers. We must know the units used 
to calculate the resolution -- meters, for our data. This means that 
if the data are 1x1 resolution, that each pixel represents a 1 x 1 meter area
on the ground.

![raster resolution]({{ site.baseurl}}/images/raster_timeseries/raster_resolution.png)

Resolution units can be viewed using two methods: viewing the 
coordinate reference system string `crs()` OR using `@data`. 


    DSM_HARV@data

    ## An object of class ".SingleLayerData"
    ## Slot "values":
    ## logical(0)
    ## 
    ## Slot "offset":
    ## [1] 0
    ## 
    ## Slot "gain":
    ## [1] 1
    ## 
    ## Slot "inmemory":
    ## [1] FALSE
    ## 
    ## Slot "fromdisk":
    ## [1] TRUE
    ## 
    ## Slot "isfactor":
    ## [1] FALSE
    ## 
    ## Slot "attributes":
    ## list()
    ## 
    ## Slot "haveminmax":
    ## [1] TRUE
    ## 
    ## Slot "min":
    ## [1] 305.07
    ## 
    ## Slot "max":
    ## [1] 416.07
    ## 
    ## Slot "band":
    ## [1] 1
    ## 
    ## Slot "unit":
    ## [1] ""
    ## 
    ## Slot "names":
    ## [1] "HARV_dsmCrop"

When we enter `DSM_HARV@data`, we see that units were not embedded in the
`tif tags` for this raster file.

#Calculate the Min and Max Values for the Raster

When exploring raster data, we often want to know the min or max values. In
this case, we are working with elevation data, it might be useful to know the
min/max elevation range at our site.

Raster statistics are often calculated and embedded in a `geotiff` for us. 
However if they weren't already calculated, we can calculate them using the
`setMinMax()` function.


    #This is the code if min/max weren't calculated: 
    #DSM_HARV <- setMinMax(DSM_HARV) 
    
    #view the calculated min value
    minValue(DSM_HARV)

    ## [1] 305.07

    #view only max value
    maxValue(DSM_HARV)

    ## [1] 416.07

We can see that the elevation at our site ranges from 305.07m to 416.07m. Thus, 
there is not a huge amount of variability in this particular dataset.

##NoData Values in Rasters

Raster data often has a NoData value associated with it. This is a value 
assigned to pixels where no data were collected or are available. 

By default the shape of a raster is always square or rectangular. Thus, if we 
have  a dataset that has a shape that isn't square or rectangular, some pixels
at the 
edge of the raster will have no data. This often happens when the data were 
collected by an airplane which only flew over some of a particular region. 

In the image below, the pixels that are black, have no data associated with
them.
The camera did not collect data in these areas. 

![ ]({{ site.baseurl }}/images/rfigs/SR00-Raster-Structure/demonstrate-no-data-blaco-1.png) 

Below - the black edges have been assigned NoDataValues (`NA`). R doesn't render
pixels that contain no values. Instead they are assigned `NA`.

![ ]({{ site.baseurl }}/images/rfigs/SR00-Raster-Structure/demonstrate-no-data-1.png) 

###No Data Value Standard 

The assigned `NoData` value may vary across disciplines; `-9999` is a common
value 
used in both the remote sensing world and the eddy covariance world. It is also
the standard used by the <a href="http://www.neoninc.org" target="_blank"> National Ecological Observatory Network (NEON)</a>. 

If we are lucky, our geoTIFF file has a tag that tells us what the NoData value 
is. 
If we are less lucky, we can find that information in the raster's metadata.
If a NoData value was stored in the GeoTIFF tag, when `R` opens up the raster,
it will assign each instance of the value to `NA` (NoData in `R` world). Values
of `NA` will be ignored by R.

## Bad Data Values in Rasters

Bad data values are different from NoData values; they are values that show up 
in the data but do not represent anything in the real world.  How do we find bad
values?   Sometimes a raster's metadata 
will tell us the range of values for the raster, anything beyond this is 
questionable. Sometimes, we just need to use some common sense & scientific 
insight as we examine the data - just as we would for field data to identify
questionable values. 

## Create A Histogram of Raster Values

We can explore the full range of values contained within our raster using the 
`hist` function which produces a histogram. This can often help us identify 
outlier or bad data values in our raster.


    #view histogram of data
    hist(DSM_HARV,
         main="Digital Surface Model - Range of Values\n NEON Harvard Forest",
         xlab="DSM Elevation Value (m)",
         ylab="Frequency",
         col="wheat")

    ## Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...):
    ## 4% of the raster cells were used. 100000 values used.

![ ]({{ site.baseurl }}/images/rfigs/SR00-Raster-Structure/view-raster-histogram-1.png) 

Notice that an error message is thrown when `R` creates the histogram. 

`Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...): 4%
of the raster cells were used. 100000 values used.`

This error is caused by the default maximum pixels value of 100,000 associated 
with the `hist` function. This maximum value is to ensure processing efficiency
as our data become larger!

<a href="http://www.r-bloggers.com/basics-of-histograms/" target="_blank">More 
on histograms in R</a>

We can define the max pixels to ensure that all pixel values are included in the
histogram. **USE THIS WITH CAUTION** as forcing `R` to plot all pixel values
in a histogram can be problematic when dealing with very large datasets.



    #View the total number of pixels (cells) in is our raster 
    ncell(DSM_HARV)

    ## [1] 2319799

    #create histogram that includes with all pixel values in the raster
    hist(DSM_HARV, 
         maxpixels=ncell(DSM_HARV),
         main="Digital Surface Model - Range of Values\n All Pixel Values Included\n NEON Harvard Forest",
         xlab="DSM Elevation Value (m)",
         ylab="Frequency",
         col="wheat4")

![ ]({{ site.baseurl }}/images/rfigs/SR00-Raster-Structure/view-raster-histogram2-1.png) 

Note that the shape of both histograms looks similar to the previous one with
only 100,000 values. R simple creates a histogram
with a smaller representative subset of our data. The distribution of elevation
values for our `Digital Surface Model (DSM)` looks reasonable. It is likely
there are no bad data values in this particular raster.

##Raster Bands

The Digital Surface Model object (`DSM_HARV`) that we've been working with 
is a single band raster. This means that there is only one dataset stored in 
the raster: surface elevation in meters for one time period.

<figure>
    <a href="{{ site.baseurl }}/images/raster_timeseries/single_multi_raster.png">
    <img src="{{ site.baseurl }}/images/raster_timeseries/single_multi_raster.png"></a>
    <figcaption>A raster dataset can contain one or more bands. We can use the raster 
    function to import one single band from a single OR multi-band raster. Source: NEON, Inc.</figcaption>
</figure>

We can view the number of bands in a raster using the `nlayers()` method. 


    #view unmber of bands
    nlayers(DSM_HARV)

    ## [1] 1

However, raster data can also be multi-band meaning that within one file it
contains data on multiple variables for each cell. By default the `raster` 
function only imports the first band in a raster regardless of whether it has 1
or more bands.  The fourth lesson in this series is a tutorial on multi-band 
rasters, <a href="{{ site.baseurl }}/NEON-R-Spatial-Raster/R/Multi-Band-Rasters-In-R/" target="_blank">  Work with Multi-band Rasters: Images in R</a>.

##View Raster File Attributes
Remember that a `GeoTIFF` contains a set of embedded tags that contain 
metadata about the raster. So far, we've explored raster metadata AFTER
importing it in `R`. However, we can use the `GDALinfo("path-to-raster-here")`
function to view raster metadata before we open a file in `R`.


    # view attributes before opening file
    GDALinfo("NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif")

    ## rows        1367 
    ## columns     1697 
    ## bands       1 
    ## lower left origin.x        731453 
    ## lower left origin.y        4712471 
    ## res.x       1 
    ## res.y       1 
    ## ysign       -1 
    ## oblique.x   0 
    ## oblique.y   0 
    ## driver      GTiff 
    ## projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
    ## file        NEON_RemoteSensing/HARV/DSM/HARV_dsmCrop.tif 
    ## apparent band summary:
    ##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
    ## 1 Float64           TRUE       -9999          1       1697
    ## apparent band statistics:
    ##     Bmin   Bmax    Bmean      Bsd
    ## 1 305.07 416.07 359.8531 17.83169
    ## Metadata:
    ## AREA_OR_POINT=Area

Notice a few things in the output:

1. A projection is described in a string - this format is called `proj4`:
   `+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs `
2. We can identify a NoData Value: -9999
3. We can tell how many `bands` the file contains: 1
4. We can view the x and y `resolution` of the data: 1
5. We can see the min and max values of the data: `Bmin` and `Bmax`.

It is ideal to use `GDALinfo` to explore your file BEFORE reading it into `R`.

#Challenge: Explore Raster Metadata 

Without using the `raster` function to read the file into `R`, determine the
following about the  `NEON_RemoteSensing/HARV/DSM/HARV_DSMhill.tif` file:

1. Does this file has the same `CRS` as `DSM_HARV`?
2. What is the `NoData` value?
3. What is resolution of the raster data? 
4. How large would a 5x5 pixel area would be on the Earth's surface? 
5. Is the file is a multi- or single-band raster?

NOTE: this file is a `hillshade`. We will learn about hillshades in <a href="{{ site.baseurl }}/NEON-R-Spatial-Raster/R/Multi-Band-Rasters-In-R/" target="_blank">  Work with Multi-band Rasters: Images in R</a>.


