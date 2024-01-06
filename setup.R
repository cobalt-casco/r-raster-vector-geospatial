options(timeout = max(300, getOption('timeout')))
## file structure

if (! file.exists("data/maine_gov_maps")) {
    dest <- tempfile()
    download.file("https://figshare.com/ndownloader/files/43930998", dest,
                  mode = "wb")
    unzip(dest, exdir = "data")
}

if (! file.exists("data/landsat_casco")) {
    dest <- tempfile()
    download.file("https://figshare.com/ndownloader/files/43930980", dest,
                  mode = "wb")
    unzip(dest, exdir = "data")
}

if (! file.exists("data/maine_gov_seagrass")) {
    dest <- tempfile()
    download.file("https://figshare.com/ndownloader/files/43930989", dest,
                  mode = "wb")
    unzip(dest, exdir = "data")
}

if (! file.exists("data/modis")) {
    dest <- tempfile()
    download.file("https://figshare.com/ndownloader/files/43931004", dest,
                  mode = "wb")
    unzip(dest, exdir = "data")
}

if (! file.exists("data/maine_dmr")) {
  dest <- tempfile()
  download.file("https://figshare.com/ndownloader/files/43930986", dest,
                mode = "wb")
  unzip(dest, exdir = "data")
}


if (! file.exists("data/Global/Boundaries/ne_110m_graticules_all")) {
    dest <- tempfile()
    download.file("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_graticules_all.zip",
                  dest, mode = "wb")
    unzip(dest, exdir = "data/Global/Boundaries/ne_110m_graticules_all")
}

if (! file.exists("data/Global/Boundaries/ne_110m_land")) {
    dest <- tempfile()
    download.file("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip",
                  dest, mode = "wb")
    unzip(dest, exdir = "data/Global/Boundaries/ne_110m_land")
}
