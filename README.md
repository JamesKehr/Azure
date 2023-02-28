# Azure
A collection of scripts I use for Azure related things.


# IPv6

File: Get-AzPrivateIPv6Subnet.ps1

This script generates an Azure compatible Local Unicast IPv6 address space based on RFC 4193. The script uses "fd" as the base IPv6 prefix, followed by a single 40-bit pseudo-random Global ID, and initially creates a single pseudo-random 16-bit Subnet ID.

      | 7 bits |1|  40 bits   |  16 bits  |          64 bits           |
      +--------+-+------------+-----------+----------------------------+
      | Prefix |L| Global ID  | Subnet ID |        Interface ID        |
      +--------+-+------------+-----------+----------------------------+

## Properties

### [string]Prefix

This value MUST BE "fd", per RFC 4193, until a future RFC defines the 0 value for the L bit.

### [string]GlobalID

This it the 40-bit pseudo-random Global ID. There MUST BE only a single GlobalID per instance.

### [string[]]SubnetID

A string array of 16-bit pseudo-random Subnet IDs.

## Methods

### GetAzVnet()

Outputs the /48 subnet string. This can be used as the Azure virtual network (vnet) address space.

### GetAzSubnet([int|string])

Outputs the /64 subnet string. This can be used as the address space for a single subnet within the vnet with the matching Global ID (see GetAzVnet()).

#### int

This is the array position, within SubnetID, that must be used to generate the address space string.


#### string

The Subnet ID string, within SubnetID, that must be used to generate the address space string. The string must be in SubnetID.

### AddAzSubnet()

Generates a new Subnet ID and adds it to 


## Usage

```PowerShell
# create the base /48 with a randomly generated Global ID and Subnet ID
$ipv6 = iwr https://raw.githubusercontent.com/JamesKehr/Azure/main/Get-AzPrivateIPv6Subnet.ps1 | iex

# get the Global ID
$ipv6.GlobalID

# get the array of Subnet IDs
$ipv6.SubnetID

# output the Azure vnet subnet string
# which is the fd:<Global ID>::\48 string used as the Azure Virtual Network IPv6 address space
$ipv6.GetAzVnet()

# output the default, auto-generated, subnet strung
# used by a subnet within the vnet, using the format: fd:<Global ID>:<Subnet ID>::\64
# the int is based on programming array standard, so the first position is 0, not 1.
$ipv6.GetAzSubnet(0)

# -OR-
$ipv6.GetAzSubnet($ipv6.SubnetID[0])

# generate a new psudeo-random Subnet ID
$ipv6.AddSubnetID()

# this adds a new entry into the SubnetID list
$ipv6.SubnetID

# output the subnet address for the newly generated Subnet ID
$ipv6.GetAzSubnet(1)
```
