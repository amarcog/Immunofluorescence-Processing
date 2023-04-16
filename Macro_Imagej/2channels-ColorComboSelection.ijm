//Set your output folder

output = "/Users/andresmg/Downloads/Upwork-Sulaiman/Processed/" // D:/Users/AndresM/KO-Processed/

//Fill with your file extension (Type ".extension")

extension = ".tif";

//Set names of your channels with the same order that appears in open images

name_ch1 = "MOMA";
name_ch2 = "DAPI";

//Set colours of your channels (Entry values should be as "Grays", "Red", "Green", "Blue", "Cyan", "Magenta", "Yellow")

Color_ch1 = "Green";
Color_ch2= "Blue";

//Set Projection (Types: "Max Intensity", "Average Intensity", "Min Intensity", "Sum Slices", "Median", "Standard Deviation")

Projection = "No";

Pro_type_ch1 = "Max Intensity";
Pro_type_ch2 = "Max Intensity";

//Set start and end of Z projection

start = "1"
end = "21"

//Set scale bar

scale_bar = "200"

//From now on the script will run w/o changes
//Only if it is requigrays, command lines related with adjustment 
//of brightness/contrast and filtering could be added


title = getTitle();titlewoext = replace(title, extension, "");

run("Split Channels");

FIJI_ch1_ID = "C1-" + title; 
FIJI_ch2_ID = "C2-" + title; 

//Project

if (Projection == "Yes") {

selectWindow(FIJI_ch1_ID);run("Z Project...", "start="+start+" stop="+end+" projection=["+Pro_type_ch1+"]");close(FIJI_ch1_ID);
selectWindow(FIJI_ch2_ID);run("Z Project...", "start="+start+" stop="+end+" projection=["+Pro_type_ch2+"]");close(FIJI_ch2_ID);


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

if (Pro_type_ch1 == Pro_type_ch2) { 
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

//Add commands in case you want to adjust brightness/contrast or filtering
//Next inactive lines include some example of these commands:

selectWindow(FIJI_ch1_ID); setMinAndMax(49, 230); //run("Subtract Background...", "rolling=50");setMinAndMax(1000, 30000);
selectWindow(FIJI_ch2_ID); setMinAndMax(21, 95); //run("Subtract Background...", "rolling=50");run("Median...", "radius=2"):

waitForUser("adjust channels separately");

//Create composite channels

run("Merge Channels...", "c1=["+FIJI_ch1_ID+"] c2=["+FIJI_ch2_ID+"] keep create");
saveAs("Tiff", ""+output+""+titlewoext+"_Composite.tif");

waitForUser("Adjust brightness/contrast in composite");

selectWindow(""+titlewoext+"_Composite.tif"); run("Split Channels");

//Rename colours from composite

FIJI_ch1_ID = "C1-" +titlewoext+ "_Composite.tif";
selectWindow(FIJI_ch1_ID);run(Color_ch1);
FIJI_ch2_ID = "C2-" +titlewoext+ "_Composite.tif";
selectWindow(FIJI_ch2_ID);run(Color_ch2);

run("Merge Channels...", "c1=["+FIJI_ch1_ID+"] c2=["+FIJI_ch2_ID+"] keep create");
run("RGB Color");saveAs("Tiff", ""+output+""+titlewoext+"_Merge-all.tif");

//Save individual channels as RGB

selectWindow(FIJI_ch1_ID);run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_"+Color_ch1+"-"+name_ch1+".tif");

selectWindow(FIJI_ch2_ID);run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_"+Color_ch2+"-"+name_ch2+".tif");

//Save merge with scales

selectWindow(""+titlewoext+"_Merge-all.tif");height = getHeight();
run("Scale Bar...", "width="+scale_bar+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_Merge-all-wscale.tif");

//Generate montage.

run("Concatenate...", "  title=[Stack] image1=["+titlewoext+"_"+Color_ch1+"-"+name_ch1+".tif] image2=["+titlewoext+"_"+Color_ch2+"-"+name_ch2+".tif] image3=["+titlewoext+"_Merge-all-wscale.tif]");
run("Make Montage...", "columns=3 rows=1 first=1 last=3");
selectWindow("Montage");
saveAs("Tiff", ""+output+""+titlewoext+"_Montage.tif");
