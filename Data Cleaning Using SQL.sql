
select * from NashvilleHousing

/* Standardize Date Format */

alter table NashvilleHousing
add Saledateconverted date

update NashvilleHousing
set Saledateconverted = convert(date, SaleDate)

select Saledateconverted, convert(date, SaleDate)
from NashvilleHousing

/* Populate Property Address Data */

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

/* Breaking Address with City and State */

select PropertyAddress 
from NashvilleHousing

select substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)  -1) as Address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as City
from NashvilleHousing

alter table NashvilleHousing
add Property_Address nvarchar(100)

update NashvilleHousing
set Property_Address = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)  -1)

alter table NashvilleHousing
add Property_City nvarchar(100)

update NashvilleHousing
set Property_City = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select OwnerAddress
from NashvilleHousing

select PARSENAME(replace(OwnerAddress, ',','.'), 3),
PARSENAME(replace(OwnerAddress, ',','.'), 2),
PARSENAME(replace(OwnerAddress, ',','.'), 1)
from NashvilleHousing

alter table NashvilleHousing
add Owner_Address nvarchar(100)

update NashvilleHousing
set Owner_Address = PARSENAME(replace(OwnerAddress, ',','.'), 3)

alter table NashvilleHousing
add Owner_City nvarchar(100)

update NashvilleHousing
set Owner_City = PARSENAME(replace(OwnerAddress, ',','.'), 2)

alter table NashvilleHousing
add Owner_State nvarchar(100)

update NashvilleHousing
set Owner_State = PARSENAME(replace(OwnerAddress, ',','.'), 1)

select * from NashvilleHousing

/* Change Y and N to Yes and No */

select distinct(SoldAsVacant)
from NashvilleHousing

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

/* Remove Duplicates */

Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY UniqueID
) row_num 
from NashvilleHousing
order by row_num desc

with rownumcte as (Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY UniqueID
) row_num 
from NashvilleHousing
)
Delete
From RowNumCTE
Where row_num > 1
-- Order by PropertyAddress

/* Removing Unwanted Column */

select * from NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate