# Pseudo data generator for AutoEPID

These purpose of these scripts is to generate some pseudo 2D dose data to simulate those captured using an EPID as well as those exported from Pinnacle TPS.

## Usage

Use the ```generatePseudoDose``` function to generate 2D dose grids with some shape inside. The function takes the following arguments:

```
generatePseudoDose(width, height, minDose, maxDose)
```

where

* width: The width of the output
* height: The height of the output
* minDose: The dose value (Gy) outside of any shape
* maxDose: The dose value (Gy) within the defined shape (only required when defining a shape)

Calling:

```
D = generatePseudoDose(10, 10, 2.0);
```

will output a 10x10 uniform dose map with a value of 2Gy.

### Shapes

To place a rectangle within the dose grid, use:

```
D = generatePseudoDose(10, 10, 2.0, 3.0, ...
    'shape', 'rectangle', ...
    'rectWidth', 4, ...
    'rectHeight', 2, ...
    'center', [5 5]);
```

This will place a 4x2 rectangle with dose 3.0Gy at the centre (5,5) of a 10x10 grid with a value of 2.0Gy outside of the rectangle.

To place a cone, use:

```
D = generatePseudoDose(10, 10, 2.0, 3.0, ...
    'shape', 'cone', ...
    'radius', 4, ...
    'interpolation', 'linear',...
    'center', [3 3])
```

Will generate a cone like structure with a radius of 4 pixels at position 3,3 within a 10x10 grid. A value of 2.0Gy will be given to outside of the cone. Within the cone's radius the values will be linearly interpolated from 2.0Gy to 3.0Gy.

To use a discrete interpolation, with 3 different levels within the cone, use:

```
D = generatePseudoDose(10, 10, 2.0, 3.0, ...
    'shape', 'cone', ...
    'radius', 4, ...
    'interpolation', 'discrete',...
    'levels', 3,...
    'center', [3 3])
```
### Saving Data

**Important**: EPID data is saved as a HIS file, beware of the maximum dose value used. The maximum pixel value stored by HIS is 65535, so if a scaling factor is applied before writing the HIS file, it should be ensured that the resulting value is below 65535.

E.g. The maximum possible dose value for a scaling factor of 8.2004e-05 is 65535*8.2004e-05 = 5.37Gy

To save the data in the AutoEPID directory structure:

```
saveData(outputPath, patientID, patientName, epidDose, tpsDose);
```

This will save the epid dose in HIS format and the TPS does in Pinnacle format. The resulting structure will match that expected by AutoEPID, within the ```outputPath```.

See ```GeneratePseudoScript.m``` for some examples.

## Author

* **Phillip Chlap** 
(phillip.chlap@unsw.edu.au)
