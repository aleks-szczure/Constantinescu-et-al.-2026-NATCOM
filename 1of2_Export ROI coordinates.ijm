// SCRIPT 1/2: Create manually a ROI around X and export as .csv file
// Input: folder (single directory) containing pos.out file with SPT localizations and image of Xist in Green channel
//        Note: the directory should not contain any other .tif images than 2D images of X (green channel)
//        Note 2: Keep names of pos.out files and .tiff X-chromosome images the same - that's important for SCRIPT2/2!
//        Note 3: It is crucial to drop polygon points around X-chromosome CLOCKWISE !!!!
//        Note 4: spsrt from X-chromosome it asks to indicate another random region too - 23-9-2022
// Output: coordinates of Polygon (indicated manually) around X_chromosome
// In the next script the coordinates of X indicated by the user are used to filter localization matrix for X localizations only
//                                                             A.Szczurek 2022
close("*");
inputFolder = getDirectory("D:\SPT\ML_Day 0 vs Day 7\24.03.2022\Day 0_1Hz_Xi analysis"); // Diretory with .tif single cell movies 
listFiles = getFileList(inputFolder);


for (n = 0; n < listFiles.length; n++){  // n corresponds to SPT FOV number in the directory
	if(endsWith(listFiles[n],".tif")){  //indicate images
		open(inputFolder + listFiles[n]); image=getTitle();
		imgName_Final=getTitle();
		
		// Change image properites such the coordinates are given in pixels:
		run("Properties...", "channels=1 slices=1 frames=1 pixel_width=1 pixel_height=1 voxel_depth=1");
		
		//print(imgName_Final);
		waitForUser("Indicate X-chrom ROI polygon using Multi-points CLOCKWISE (not line!)! Then press ENTER!"); 
			// use ROI manager to save X,Y coordinates of multipoints around Xist for polygon (Script 2/2):
			run("ROI Manager...");
			roiManager("Add");
			roiManager("Measure");
			saveAs("Results",inputFolder+listFiles[n]+"_Xchrom.csv"); close("statistics"); 
			roiManager("Delete"); // delete the ROI (set of points) so that there is only one set of ROIs present at the time
			   	selectWindow("Results"); //clear results
               	run("Close" );
               	selectWindow(imgName_Final); run("Close" );   //2022-09-23, fixed bug
               	open(inputFolder + listFiles[n]); image=getTitle(); //close and reload the same image
		       	imgName_Final=getTitle();
		       		// Change image properites such the coordinates are given in pixels:
		            run("Properties...", "channels=1 slices=1 frames=1 pixel_width=1 pixel_height=1 voxel_depth=1");
					wait(500);
			///// NEW 17-08-2022 - Add random ROI
		waitForUser("Indicate RANDOM X-chrom ROI polygon using Multi-points CLOCKWISE  Then press ENTER!"); 
			//use ROI manager to save X,Y coordinates of multipoints around Xist for polygon (Script 2/2):
			run("ROI Manager...");
			roiManager("Add");
			roiManager("Measure");
			saveAs("Results",inputFolder+listFiles[n]+"_Random.csv"); close("statistics"); 
			roiManager("Delete"); // delete the ROI (set of points) so that there is only one set of ROIs present at the time
			wait(500);
            //////
				close(image); 
		
				// Loop that closes all open windows before user proceeds to the next image:
				listWin = getList("window.titles"); setBatchMode(true);
     			for (j=0; j<listWin.length; j++){
     			winame = listWin[j];
      			selectWindow(winame);
     			run("Close");
     			} setBatchMode(false);
		
	}
}
