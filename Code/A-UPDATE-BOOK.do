////////////////////////////////////////////////////////
// UPDATE BOOK FIGURES AND TABLES
////////////////////////////////////////////////////////
/* This script will use the most up to date data
available on FRED in the figures/tables. This means
that the results in the tables may be slightly different
than what I have in the book. Figures will also look
slightly different, and labels may be a little off
*/

////////////////////////////////////////////////////////
// USER INPUT NEEDED HERE
////////////////////////////////////////////////////////
/* The only thing you should change is the "cd" command
to set the working directory where you downloaded all 
the code and data to. That directory includes
sub-folders for "Code", "Data", "Drafts", and "Work". 
All the data should be in "Data", all the code should
be in "Code". "Drafts" and "Work" should start empty
*/
cd "/users/dietz/dropbox/project/wheregrowth"

////////////////////////////////////////////////////////
// NO EDITS NEEDED AFTER THIS
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Load programs and set parameters 
////////////////////////////////////////////////////////

// Install necessary packages - capture rc in case they are already installed
//capture ssc install freduse // utility to download FRED data
//capture net install gr0070.pkg // plotplain figure scheme
//capture ssc install egenmore // some additional data commands
do "./Code/Prog-Publish.do" // loads program that pushes figures to blog

// Set options for formatting of figures
graph set window fontface "Garamond"
set scheme plotplain 

global PUBLISH = 0 // flag for my use to push output to blog, leave = 0

////////////////////////////////////////////////////////
// Data preparation scripts
////////////////////////////////////////////////////////
do "./Code/Data-Save-Raw.do" // Create Stata datasets from various CSV files
do "./Code/Data-CPS-HC.do" // Format CPS data on education and experience
do "./Code/Data-METRO-Prepare.do" // Format Metro level data from BLS, BEA
do "./Code/Data-KLEMS-Prepare.do" // Read KLEMS spreadsheet and reshape
do "./Code/Data-FRED-Extract.do" // Extract FRED data on main aggregates
do "./Code/Data-FRED-State.do" // Extract FRED data on state-level GDP and workforce
// Combine several datasets into one master dataset
do "./Code/Data-Merge-Calculate.do" // Merge annual datasets together, must run after other data scripts

////////////////////////////////////////////////////////
// Figures
////////////////////////////////////////////////////////
do "./Code/Plot-Ch2-Fig1-3.do"
do "./Code/Plot-Ch2-Fig4-7.do"
do "./Code/Plot-Ch2-Fig8.do"

do "./Code/Plot-Ch3-Fig1-2.do"
do "./Code/Plot-Ch3-Fig3.do"
do "./Code/Plot-Ch3-Fig4-5.do"
do "./Code/Plot-Ch3-Fig6-7.do"
do "./Code/Plot-Ch3-Fig8.do"

do "./Code/Plot-Ch4-Fig1.do"
do "./Code/Plot-Ch4-Fig2.do"
do "./Code/Calc-Ch4-Tab1-2.do"

do "./Code/Plot-Ch5-Fig1.do"
do "./Code/Plot-Ch5-Fig2-3.do"
do "./Code/Calc-Ch5-Tab1.do"

do "./Code/Plot-Ch6-Fig1.do"

do "./Code/Plot-Ch7-Fig1-3.do"
do "./Code/Calc-Ch7-Tab1.do"

do "./Code/Plot-Ch8-Fig1.do"
do "./Code/Plot-Ch8-Fig2.do"

do "./Code/Plot-Ch9-Fig1.do"

do "./Code/Plot-Ch10-Fig1-2.do"
do "./Code/Plot-Ch10-Fig3.do"

do "./Code/Plot-Ch11-Fig1.do"

do "./Code/Plot-Ch12-Fig1-6.do"

do "./Code/Plot-Ch13-Fig1.do"
do "./Code/Plot-Ch13-Fig2.do"
do "./Code/Plot-Ch13-Fig3-5.do"
do "./Code/Plot-Ch13-Fig6.do"

do "./Code/Plot-Ch14-Fig1-2.do"
do "./Code/Plot-Ch14-Fig3.do"

do "./Code/Plot-Ch15-Fig1-2.do"
do "./Code/Plot-Ch15-Fig3.do"

do "./Code/Plot-Ch16-Fig1-2.do"
