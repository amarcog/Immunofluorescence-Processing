//Set your output folder

output = "/Users/andresmg/Downloads/Test_NewMacro/Processed/" // D:/Users/AndresM/KO-Processed/

//Fill with your file extension (Type ".extension")

extension = ".czi";

//Set names of your channels with the same order that appears in open images

name_ch1 = "DAPI";
name_ch2 = "WT1";
name_ch3 = "ACE2";

//Set colours of your channels (Entry values should be as "Grays", "Red", "Green", "Blue", "Cyan", "Magenta", "Yellow")

Color_ch1 = "Blue";
Color_ch2= "Red";
Color_ch3= "Green";

//Set Projection (Types: "Max Intensity", "Average Intensity", "Min Intensity", "Sum Slices", "Median", "Standard Deviation")

Projection = "Yes";

Pro_type_ch1 = "Max Intensity";
Pro_type_ch2 = "Max Intensity";
Pro_type_ch3 = "Max Intensity";

//Set start and end of Z projection

start = "1"
end = "21"

//Set Crop Proportion (For example a value of 3 means that the selected area will be 3 times lower than the full image)

proportion = 3

//Set scale bar

scale_bar = "200"

//From now on the script will run w/o changes
//Only if it is requigrays, command lines related with adjustment 
//of brightness/contrast and filtering could be added

title = getTitle();titlewoext = replace(title, extension, "");

//Measure image dimensions to set the Crop

//Ask user to put the identificator of the crop

CropID = "CropID-" + getString("Introduce crop ID", "");

selectWindow(""+title+"");width = getWidth; height = getHeight;

//Create rectangle with the highest dimension

if (width>height)
	higherdim = width;
else
	higherdim = height;

Rectsize = higherdim/proportion; //the size of the Rectangle is set up as a proportion from the highest dimension

makeRectangle(0, 3, Rectsize, Rectsize); waitForUser("Set Position of the Rectangle");

//Duplicate

run("Duplicate...", "duplicate");

run("Split Channels");

FIJI_ch1_ID = "C1-" + titlewoext + "-1" + extension; 
FIJI_ch2_ID = "C2-" + titlewoext + "-1" + extension;
FIJI_ch3_ID = "C3-" + titlewoext + "-1" + extension; 

//Project

if (Projection == "Yes") {

selectWindow(FIJI_ch1_ID);run("Z Project...", "start="+start+" stop="+end+" projection=["+Pro_type_ch1+"]");close(FIJI_ch1_ID);
selectWindow(FIJI_ch2_ID);run("Z Project...", "start="+start+" stop="+end+" projection=["+Pro_type_ch2+"]");close(FIJI_ch2_ID);
selectWindow(FIJI_ch3_ID);run("Z Project...", "start="+start+" stop="+end+" projection=["+Pro_type_ch3+"]");close(FIJI_ch3_ID);


function FIJI_ID_after_projection(FIJI_ch_ID,Pro_type_ch) {

	if (Pro_type_ch == "Max Intensity") {
		ID_after_projection = "MAX_" + FIJI_ch_ID;
	} else if (Pro_type_ch == "Sum Slices") {
		ID_after_projection = "SUM_" + FIJI_ch_ID;
	} else if (Pro_type_ch == "Average Intensity") {
		ID_after_projection = "AVG_" + FIJI_ch_ID;
	} else if (Pro_type_ch == "Min Intensity") {
		ID_after_projection = "MIN_" + FIJI_ch_ID;
	} else if (Pro_type_ch == "Median") {
		ID_after_projection = "MED_" + FIJI_ch_ID;
	} else if (Pro_type_ch == "Standard Deviation") {
		ID_after_projection = "STD_" +FIJI_ch_ID;
	} 

	return ID_after_projection;
	}


//Rename after projections

FIJI_ch1_ID = FIJI_ID_after_projection(FIJI_ch1_ID,Pro_type_ch1);
FIJI_ch2_ID = FIJI_ID_after_projection(FIJI_ch2_ID,Pro_type_ch2);
FIJI_ch3_ID = FIJI_ID_after_projection(FIJI_ch3_ID,Pro_type_ch3);

if ((Pro_type_ch1 == Pro_type_ch2) & (Pro_type_ch1 == Pro_type_ch3)) { 
	run("Select None"); 
	} else {
		selectWindow(FIJI_ch1_ID);run("16-bit");
		selectWindow(FIJI_ch2_ID);run("16-bit");
		selectWindow(FIJI_ch3_ID);run("16-bit");
		}
}

run("Tile");

//Put colors

selectWindow(FIJI_ch1_ID);run(Color_ch1);
selectWindow(FIJI_ch2_ID);run(Color_ch2);
selectWindow(FIJI_ch3_ID);run(Color_ch3);

//Add commands in case you want to adjust brightness/contrast or filtering
//Next inactive lines include some example of these commands:

selectWindow(FIJI_ch1_ID); //run("Subtract Background...", "rolling=50");setMinAndMax(1000, 30000);
selectWindow(FIJI_ch2_ID); //run("Subtract Background...", "rolling=50");
selectWindow(FIJI_ch3_ID);//setMinAndMax(3000, 41000); //run("Subtract Background...", "rolling=100");run("Median...", "radius=2"

waitForUser("adjust channels separately");

//Create composite channels

run("Merge Channels...", "c1=["+FIJI_ch1_ID+"] c2=["+FIJI_ch2_ID+"] c3=["+FIJI_ch3_ID+"] keep create");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_Composite.tif");

waitForUser("Adjust brightness/contrast in composite");

selectWindow(""+titlewoext+"-"+CropID+"_Composite.tif"); run("Split Channels");

//Rename colours from composite

FIJI_ch1_ID = "C1-" +titlewoext+ "-" +CropID+ "_Composite.tif";
FIJI_ch2_ID = "C2-" +titlewoext+ "-" +CropID+ "_Composite.tif";
FIJI_ch3_ID = "C3-" +titlewoext+ "-" +CropID+ "_Composite.tif";

run("Merge Channels...", "c1=["+FIJI_ch1_ID+"] c2=["+FIJI_ch2_ID+"] c3=["+FIJI_ch3_ID+"] keep");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_Merge-all.tif");

run("Merge Channels...", "c2=["+FIJI_ch2_ID+"] c3=["+FIJI_ch3_ID+"] create keep");
run("RGB Color");saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch1+".tif");

run("Merge Channels...", "c1=["+FIJI_ch1_ID+"] c3=["+FIJI_ch3_ID+"] create keep");
run("RGB Color");saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch2+".tif");

run("Merge Channels...", "c1=["+FIJI_ch1_ID+"] c2=["+FIJI_ch2_ID+"] create keep");
run("RGB Color");saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch3+".tif");

//Save individual channels as RGB

selectWindow(FIJI_ch1_ID);run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_"+Color_ch1+"-"+name_ch1+".tif");

selectWindow(FIJI_ch2_ID);run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_"+Color_ch2+"-"+name_ch2+".tif");

selectWindow(FIJI_ch3_ID);run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_"+Color_ch3+"-"+name_ch3+".tif");

//Save merge with scales

selectWindow(""+titlewoext+"-"+CropID+"_Merge-all.tif");height = getHeight();
run("Scale Bar...", "width="+scale_bar+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_Merge-all-wscale.tif");

selectWindow(""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch1+".tif");height = getHeight();
run("Scale Bar...", "width="+scale_bar+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch1+"-wscale.tif");

selectWindow(""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch2+".tif");height = getHeight();
run("Scale Bar...", "width="+scale_bar+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch2+"-wscale.tif");

selectWindow(""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch3+".tif");height = getHeight();
run("Scale Bar...", "width="+scale_bar+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"-"+CropID+"_MergeWO-"+name_ch3+"-wscale.tif");

//Generate montage.

run("Concatenate...", "  title=[Stack] image1=["+titlewoext+"-"+CropID+"_"+Color_ch1+"-"+name_ch1+".tif] image2=["+titlewoext+"-"+CropID+"_"+Color_ch2+"-"+name_ch2+".tif] image3=["+titlewoext+"-"+CropID+"_"+Color_ch3+"-"+name_ch3+".tif] image4=["+titlewoext+"-"+CropID+"_Merge-all-wscale.tif]");
run("Make Montage...", "columns=4 rows=1 first=1 last=4");
selectWindow("Montage");
saveAs("Tiff", ""+output+""+titlewoext+"_Montage.tif");
