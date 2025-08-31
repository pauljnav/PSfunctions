<#
.SYNOPSIS
    Pester tests for the ConvertTo-KM function.

.DESCRIPTION
    This script contains Pester tests to verify the correct functionality of the
    ConvertTo-KM function from the 'convert-distance.ps1' file.
#>
Describe 'ConvertTo-KM' {
    # Dot-source the main script to make the function available for testing
    BeforeAll {
        . "$PSScriptRoot/ConvertDistance.ps1"
    }

    # Test each conversion unit with a known value
    Context 'Valid Conversions' {
        It 'should correctly convert miles to kilometers' {
            # 10 miles should be approximately 16.0934 kilometers
            (ConvertTo-KM -Mile 10) | Should beApproximately 16.0934
        }

        It 'should correctly convert yards to kilometers' {
            # 500 yards should be approximately 0.4572 kilometers
            (ConvertTo-KM -Yard 500) | Should beApproximately 0.4572
        }

        It 'should correctly convert feet to kilometers' {
            # 100 feet should be approximately 0.03048 kilometers
            (ConvertTo-KM -Foot 100) | Should beApproximately 0.03048
        }

        It 'should correctly convert inches to kilometers' {
            # 12 inches should be approximately 0.0003048 kilometers
            (ConvertTo-KM -Inch 12) | Should beApproximately 0.0003048
        }

        It 'should correctly convert nautical miles to kilometers' {
            # 1 nautical mile should be approximately 1.852 kilometers
            (ConvertTo-KM -NauticalMile 1) | Should beApproximately 1.852
        }

        It 'should correctly convert meters to kilometers' {
            # 1000 meters should be exactly 1 kilometer
            (ConvertTo-KM -Meter 1000) | Should be 1
        }

        It 'should correctly convert centimeters to kilometers' {
            # 100000 centimeters should be exactly 1 kilometer
            (ConvertTo-KM -Centimeter 100000) | Should be 1
        }

        It 'should correctly convert millimeters to kilometers' {
            # 1000000 millimeters should be exactly 1 kilometer
            (ConvertTo-KM -Millimeter 1000000) | Should be 1
        }
    }

    # Test for invalid usage
    Context 'Invalid Usage' {
        It 'should throw an error when multiple parameters are used' {
            { ConvertTo-KM -Mile 10 -Yard 50 } | Should Throw
        }

        It 'should throw an error when no parameter is used' {
            { ConvertTo-KM } | Should Throw
        }
    }
}
