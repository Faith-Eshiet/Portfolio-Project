/*
Data Cleaning in SQL

Let's view the entire dataset
*/

SELECT *
FROM NashvilleHousing


-- Converting the SaleDate column from datetime to date

ALTER TABLE NashvilleHousing
ADD SalesDateNew Date

UPDATE NashvilleHousing
SET SalesDateNew = CONVERT(DATE,SaleDate)

-- Checking the result

SELECT SalesDateNew, CONVERT(DATE,SaleDate)
FROM NashvilleHousing


/* Populating the PropertyAddress column.

We will use the relationship between the ParcelID and the PropertyAddress to do this.
*/

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From NashvilleHousing AS a
JOIN NashvilleHousing AS b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

-- Checking the result

SELECT *
FROM NashvilleHousing
Where PropertyAddress is null


-- Breaking out PropertyAddress into Individual Columns (Address and City)


Select PropertyAddress
From NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City

From NashvilleHousing

-- Address Column
ALTER TABLE NashvilleHousing
Add PropertyAddressNew Nvarchar(255);

Update NashvilleHousing
SET PropertyAddressNew = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


-- City Column
ALTER TABLE NashvilleHousing
Add PropertyCity Nvarchar(255);

Update NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



-- Checking the result
Select *
From NashvilleHousing


-- Breaking out OwnerAddress into Individual Columns (Address, City and State)

Select OwnerAddress
From NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) AS Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) AS City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) AS State
From NashvilleHousing


-- Address Column
ALTER TABLE NashvilleHousing
Add OwnerAddressNew Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressNew = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


-- City Column
ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



--State Column
ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- Checking the result
Select *
From NashvilleHousing



-- Changing Y and N to Yes and No in SoldAsVacant column

Select Distinct(SoldAsVacant)
From NashvilleHousing


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

-- Checking the result
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2



-- Remove Duplicates

WITH RowCounts AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS row_count

From NashvilleHousing
)
DELETE
From RowCounts
Where row_count > 1



-- Delete Unused Columns


ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict


-- Checking the result
Select *
From NashvilleHousing
