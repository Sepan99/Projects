-- Updating Saledate column to remove the unnecessary time

ALTER Table nashvillehousing2
ALTER column SaleDate date

select * from NashvilleHousing2
-- Eliminating the null values from PropertyAddress

select a.ParcelID, b.ParcelID, a. PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing2 a
join NashvilleHousing2 b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing2 a
join NashvilleHousing2 b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null


-- Break the PropertyAddress column into 2 different columns

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Adress,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
from NashvilleHousing2


ALTER Table nashvillehousing2
ADD Adress nvarchar(255)

ALTER Table nashvillehousing2
ADD City nvarchar(255)

update NashvilleHousing2
set Adress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

update NashvilleHousing2
set city = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- Break the OwnerAddress column into 3 different columns

select
PARSENAME(replace(owneraddress, ',', '.'), 3) as address,
PARSENAME(replace(owneraddress, ',', '.'), 2) as city,
PARSENAME(replace(owneraddress, ',', '.'), 1) as state
from NashvilleHousing2

ALTER Table nashvillehousing2
ADD OwneraddressV2 nvarchar(255)

ALTER Table nashvillehousing2
ADD Ownercity nvarchar(255)

ALTER Table nashvillehousing2
ADD Ownerstate nvarchar(255)

update NashvilleHousing2
set OwneraddressV2 = PARSENAME(replace(owneraddress, ',', '.'), 3)

update NashvilleHousing2
set Ownercity = PARSENAME(replace(owneraddress, ',', '.'), 2)

update NashvilleHousing2
set Ownerstate = PARSENAME(replace(owneraddress, ',', '.'), 1)



-- Changing the "Y" and "N" in SoldAsVacant to 'Yes" and "No"

select SoldAsVacant,
Case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end
from NashvilleHousing2


update NashvilleHousing2
set SoldAsVacant =  Case when soldasvacant = 'Y' then 'Yes'
						when soldasvacant = 'N' then 'No'
						else soldasvacant
						end


-- Removing duplicates

with rownumcte as (
select *,
ROW_NUMBER() over
(partition by parcelid, propertyaddress, saleprice, saledate, legalreference
order by uniqueID) row_num
from NashvilleHousing2
)


select *
from rownumcte
where row_num > 0