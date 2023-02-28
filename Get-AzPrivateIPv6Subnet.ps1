# Get-AzPrivateIPv6Subnet

[CmdletBinding()]
param ()


class AzPrivateIPv6Subnet
{
    [string] $Prefix    = "fd"
    [string]        $GlobalID
    [string[]]      $SubnetID

    hidden [string] $vnetSuffix   = "/48"
    hidden [string] $subnetSuffix = "/64"
    
    AzPrivateIPv6Subnet ()
    {
        # Generate the Global ID. This happens only once.
        for ($i = 0; $i -lt 10; $i++)
        {
            $this.GlobalID += $this.GetHexDigit()
        }

        # Generate the first Subnet ID. Multiple Subnet ID's are supported.
        $this.SubnetID += $this.NewSubnetID()

    }

    [string]
    GetAzVnet()
    {
        $tmpIPv6 = "$($this.Prefix)$($this.GlobalID)" -replace '....(?!$)', '$&:'

        # use [ipaddress] to ensure the IPv6 address is formatted correctly
        try
        {
            $tmpIPv6 = ([ipaddress]::Parse("$tmpIPv6`::")).IPAddressToString
        }
        catch
        {
            Write-Verbose "Invalid IPv6 address, $tmpIPv6`:: $_"
            return $null
        }
        
        return ("$tmpIPv6$($this.vnetSuffix)")
    }

    [string]
    GetAzSubnet([int]$index)
    {
        # make sure the index is inbound
        if ($index -lt 0 -or $index -ge $this.SubnetID.Count)
        {
            Write-Verbose "The index is out of bounds. The valid index numbers are 0 thru $($this.SubnetID.Count)."
            return $null
        }
        
        # create the formatted IPv6 address base
        $tmpIPv6 = "$($this.Prefix)$($this.GlobalID)$($this.SubnetID[$index])" -replace '....(?!$)', '$&:'

        # use [ipaddress] to ensure the IPv6 address is formatted correctly
        try
        {
            $tmpIPv6 = ([ipaddress]::Parse("$tmpIPv6`::")).IPAddressToString
        }
        catch
        {
            Write-Verbose "Invalid IPv6 address, $tmpIPv6`:: $_"
            return $null
        }

        # return the full subnet notation
        return ("$tmpIPv6$($this.subnetSuffix)")
    }

    [string]
    GetAzSubnet([string]$ID)
    {
        # make sure the ID is in SubnetID
        if ($ID -notin $this.SubnetID)
        {
            Write-Error "The Subnet ID is invalid. The valid ID's are $($this.SubnetID -join ",")."
            return $null
        }

        # create the formatted IPv6 address base
        $tmpIPv6 = "$($this.Prefix)$($this.GlobalID)$ID" -replace '....(?!$)', '$&:'
        
        # use [ipaddress] to ensure the IPv6 address is formatted correctly
        try
        {
            $tmpIPv6 = ([ipaddress]::Parse("$tmpIPv6`::")).IPAddressToString
        }
        catch
        {
            Write-Verbose "Invalid IPv6 address, $tmpIPv6`:: $_"
            return $null
        }

        # return the full subnet notation
        return ("$tmpIPv6$($this.subnetSuffix)")
    }

    [string]
    AddSubnetID()
    {
        $tmpSubID = $this.NewSubnetID()

        $this.SubnetID += $tmpSubID
        return $tmpSubID
    }

    hidden
    [string]
    NewSubnetID()
    {
        $tmpSubID = ""
        for ($i = 0; $i -lt 4; $i++)
        {
            $tmpSubID += $this.GetHexDigit()
        }

        return $tmpSubID
    }

    hidden
    [string]
    GetHexDigit()
    {
        # IPv6 address are hexidecimal numbers, so 0-F
        [string[]]$IPv6Chars = '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'

        # get a random number between 0 and 15, a random number of times
        $seedNum = Get-Random -Minimum 1 -Maximum 100

        # build an array of random numbers
        $randArr = [System.Collections.Generic.List[string]]::new()
        0..$seedNum | & { process { $null = $randArr.Add($IPv6Chars[(Get-Random -Maximum $IPv6Chars.Count)]) } }

        return ($randArr[(Get-Random -Minimum 0 -Maximum $seedNum)])
    }
}

$ipv6 = [AzPrivateIPv6Subnet]::new()

return $ipv6