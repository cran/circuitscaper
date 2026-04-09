## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----install, eval = FALSE----------------------------------------------------
# # Install circuitscaper (from GitHub during development)
# # remotes::install_github("matthewkling/circuitscaper")
# 
# library(circuitscaper)
# 
# # First time only: install Julia and required packages
# cs_install_julia()

## ----setup, eval = FALSE------------------------------------------------------
# cs_setup(julia_home = "/path/to/julia/bin")

## ----pairwise-----------------------------------------------------------------
# library(terra)
# library(circuitscaper)
# 
# # Resistance surface (higher values = harder to traverse)
# resistance <- rast(system.file("extdata/resistance.tif", package = "circuitscaper"))
# 
# # Option 1: Focal nodes as coordinates (simplest)
# coords <- matrix(c(10, 40, 40, 40, 10, 10, 40, 10), ncol = 2, byrow = TRUE)
# result <- cs_pairwise(resistance, coords)
# 
# # Option 2: Focal nodes as a raster (integer IDs; 0 and NA are not nodes)
# # locations <- rast("path/to/focal_nodes.tif")
# # result <- cs_pairwise(resistance, locations)
# 
# # Cumulative current map -- high values indicate important movement corridors
# plot(result$current_map)
# 
# # Pairwise resistance matrix -- can be used as a connectivity distance metric
# result$resistance_matrix

## ----one-to-all---------------------------------------------------------------
# result <- cs_one_to_all(resistance, coords)
# plot(result)

## ----all-to-one---------------------------------------------------------------
# result <- cs_all_to_one(resistance, coords)
# plot(result$cumulative_current)

## ----advanced-----------------------------------------------------------------
# source_layer <- rast(system.file("extdata/source.tif", package = "circuitscaper"))
# ground_layer <- rast(system.file("extdata/ground.tif", package = "circuitscaper"))
# 
# result <- cs_advanced(resistance, source_layer, ground_layer,
#                       ground_is = "conductances")
# 
# # Current density -- corridors and pinch points where flow is concentrated
# # i.e. possible preservation priorities
# plot(result[["current"]])
# 
# # Voltage -- analogous to movement probability, decreasing with distance
# # and resistance from sources
# plot(result[["voltage"]])
# 
# # Power dissipation -- areas of current flow through high-resistance areas,
# # i.e. possible restoration priorities
# plot(result[["current"]]^2 * resistance)

## ----per-pair-----------------------------------------------------------------
# result <- cs_pairwise(resistance, coords,
#                       cumulative_only = FALSE,
#                       write_voltage = TRUE)
# names(result$current_map)

## ----source-strengths, eval = FALSE-------------------------------------------
# # Strengths in the same order as the locations
# strengths <- c(2.5, 1.0, 0.5)
# result <- cs_one_to_all(resistance, coords, source_strengths = strengths)

## ----short-circuit, eval = FALSE----------------------------------------------
# polygons <- rast("path/to/short_circuit_regions.tif")
# result <- cs_pairwise(resistance, locations, short_circuit = polygons)

## ----included-pairs, eval = FALSE---------------------------------------------
# result <- cs_pairwise(resistance, locations,
#                       included_pairs = "path/to/pairs.txt")

## ----omniscape----------------------------------------------------------------
# result <- os_run(resistance, radius = 20, block_size = 3)

## ----omniscape-plot-----------------------------------------------------------
# plot(result)

## ----omniscape-source, eval = FALSE-------------------------------------------
# source_strength <- rast("path/to/habitat_quality.tif")
# 
# result <- os_run(resistance, radius = 20,
#                  source_strength = source_strength)

## ----omniscape-parallel, eval = FALSE-----------------------------------------
# # Set thread count at the start of your session
# cs_setup(threads = 4)
# 
# result <- os_run(resistance, radius = 20,
#                  block_size = 5,
#                  parallelize = TRUE)

## ----output-dir, eval = FALSE-------------------------------------------------
# result <- cs_pairwise(resistance, locations,
#                       output_dir = "my_output_directory")

