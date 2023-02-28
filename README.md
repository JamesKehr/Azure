# Azure
A collection of scripts I use for Azure related things.


# IPv6

To generate an Azure IPv6 subnet:

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
