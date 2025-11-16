@echo off
:Start
setlocal enabledelayedexpansion

cls
echo ========================================
echo        3D Print Cost Estimator
echo ========================================
echo.

:: ---------- Print time input ----------
echo Enter print time:
set /p printHours=  Hours: 
set /p printMinutes=  Minutes: 

:: ---------- Labor time input ----------
echo Enter labor time:
set /p laborHours=  Hours: 
set /p laborMinutes=  Minutes: 

:: ---------- Filament & wage (defaults) ----------
set spoolCost=30
set wage=20

set /p grams=Grams of filament used: 

:: ---------- Assembly materials ----------
set /p assemblyCost=Assembly materials cost ($): 

echo.
echo (Using defaults: Filament cost = $30/kg, Hourly wage = $20/h)
echo.

:: ---------- Material cost ----------
set /a materialCents=grams * spoolCost * 100 / 1000

:: ---------- Labor cost (labor time only) ----------
set /a totalLaborMinutes=laborHours*60 + laborMinutes

:: Apply 5 minute minimum
if %totalLaborMinutes%==0 set /a totalLaborMinutes=5

set /a laborCents=totalLaborMinutes * wage * 100 / 60

:: ---------- Electricity cost with 100% markup ----------
set /a totalPrintMinutes=printHours*60 + printMinutes
set /a electricityCents=18 * totalPrintMinutes / 60
set /a electricityCents=electricityCents * 2

:: ---------- Assembly materials ----------
set /a assemblyCents=assemblyCost * 100

:: ---------- Subtotal ----------
set /a subtotalCents=materialCents + laborCents + electricityCents + assemblyCents

:: ---------- Tax 10% ----------
set /a taxCents=subtotalCents * 10 / 100

:: ---------- Total ----------
set /a totalCents=subtotalCents + taxCents

:: ---------- Convert line items to dollars.cents ----------
set /a materialDollars=materialCents / 100
set /a materialRem=materialCents %% 100

set /a laborDollars=laborCents / 100
set /a laborRem=laborCents %% 100

set /a electricityDollars=electricityCents / 100
set /a electricityRem=electricityCents %% 100

set /a assemblyDollars=assemblyCents / 100
set /a assemblyRem=assemblyCents %% 100

set /a subtotalDollars=subtotalCents / 100
set /a subtotalRem=subtotalCents %% 100

set /a taxDollars=taxCents / 100
set /a taxRem=taxCents %% 100

:: ---------- Final price (rounded up to next whole dollar) ----------
set /a totalDollars=totalCents / 100
set /a remainder=totalCents %% 100
if not %remainder%==0 set /a totalDollars=totalDollars + 1

:: ---------- Output ----------
echo ========================================
echo                 RESULTS
echo ========================================
echo Material cost:       $%materialDollars%.%materialRem%
echo Labor (time):       $%laborDollars%.%laborRem%
echo Electricity cost:   $%electricityDollars%.%electricityRem%
echo Assembly materials:  $%assemblyDollars%.%assemblyRem%
echo ----------------------------------------
echo Subtotal:           $%subtotalDollars%.%subtotalRem%
echo Tax (10%%):          $%taxDollars%.%taxRem%
echo FINAL PRICE:        $%totalDollars%
echo ========================================

:: ---------- Ask to do another quote ----------
:AgainPrompt
set /p again=Do you want to do another quote? (Y/N): 
if /i "%again%"=="Y" goto Start
if /i "%again%"=="N" exit
echo Please enter Y or N.
goto AgainPrompt
