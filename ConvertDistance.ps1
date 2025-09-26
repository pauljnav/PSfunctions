<#
.SYNOPSIS
    Converts various units of distance to kilometers using unit-named parameters.

.DESCRIPTION
    This function takes a single value and a unit-specific parameter name to perform the conversion
    to kilometers. It is designed for direct command-line use and does not support pipeline input.
    Only one unit parameter can be used at a time.

.PARAMETER Mile
    The value in miles to be converted to kilometers.

.PARAMETER Yard
    The value in yards to be converted to kilometers.

.PARAMETER Foot
    The value in feet to be converted to kilometers.

.PARAMETER Inch
    The value in inches to be converted to kilometers.

.PARAMETER NauticalMile
    The value in nautical miles to be converted to kilometers.

.PARAMETER Meter
    The value in meters to be converted to kilometers.

.PARAMETER Centimeter
    The value in centimeters to be converted to kilometers.

.PARAMETER Millimeter
    The value in millimeters to be converted to kilometers.

.EXAMPLE
    ConvertTo-KM -Mile 10
    Converts 10 miles to kilometers.

.EXAMPLE
    ConvertTo-KM -Yard 500
    Converts 500 yards to kilometers.

.EXAMPLE
    ConvertTo-KM -Meter 5000
    Converts 5000 meters to kilometers.
#>
function ConvertTo-KM {
    [CmdletBinding(DefaultParameterSetName = 'Mile')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Mile')]
        [double]$Mile,

        [Parameter(Mandatory = $true, ParameterSetName = 'Yard')]
        [double]$Yard,

        [Parameter(Mandatory = $true, ParameterSetName = 'Foot')]
        [double]$Foot,

        [Parameter(Mandatory = $true, ParameterSetName = 'Inch')]
        [double]$Inch,

        [Parameter(Mandatory = $true, ParameterSetName = 'NauticalMile')]
        [double]$NauticalMile,

        [Parameter(Mandatory = $true, ParameterSetName = 'Meter')]
        [double]$Meter,

        [Parameter(Mandatory = $true, ParameterSetName = 'Centimeter')]
        [double]$Centimeter,

        [Parameter(Mandatory = $true, ParameterSetName = 'Millimeter')]
        [double]$Millimeter
    )

    # Use the parameter set name to determine the correct conversion
    switch ($PSCmdlet.ParameterSetName) {
        'Mile' { $Mile * 1.60934 }
        'Yard' { $Yard * 0.0009144 }
        'Foot' { $Foot * 0.0003048 }
        'Inch' { $Inch * 0.0000254 }
        'NauticalMile' { $NauticalMile * 1.852 }
        'Meter' { $Meter * 0.001 }
        'Centimeter' { $Centimeter * 0.00001 }
        'Millimeter' { $Millimeter * 0.000001 }
    }
}

# Convert 10 miles to kilometers
# ConvertTo-KM -Mile 10

# Convert 50 yards to kilometers
# ConvertTo-KM -Yard 50

# Convert 100 feet to kilometers
# ConvertTo-KM -Foot 100

# Convert 2000 millimeters to kilometers
# ConvertTo-KM -Millimeter 2000
