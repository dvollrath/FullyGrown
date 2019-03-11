# Fully Grown: Why the growth slowdown is a sign of success

## Replicating the book
To recreate the exact figures and tables, you will need Stata on your computer. Assuming you do, follow these instructions:

- Download this repository (green button towards top-right)
- Unzip the downloaded folder, and note where you put it on your computer
- Go into the "Code" folder and edit the "A-REPLICATE-BOOK.do" file
- You need to update this do-file to point to the directory on your computer where the downloaded reposity is at. See instructions in the code.
- Run it the "A-REPLICATE-BOOK.do" script, which calls everything you need and will put all figures and raw table data into the "Drafts" folder. 

## Updating the book
The book is based on data downloaded in October 2018. If you want to run updated versions of the figures and tables, you can. Rather than the "A-REPLICATE-BOOK.do" script, run the "A-UPDATE-BOOK.do" script. You'll need to edit that script to point to the directory on your computer where everything was downloaded. After that, run the script, and it will call FRED to grab updated data.

## Data sources
Much of the data is pulled directly from the [FRED](https://fred.stlouisfed.org) database hosted by the St. Louis Fed. The scripts use the "freduse" command in Stata to pull data series down for use. 

Other data sources are in CSV files in the "Data" folder. The scripts that pull these in have sources listed, and notes on any manual work I did to prepare them.  