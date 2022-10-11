//Put your output folder

output = "/Users/amarco/Desktop/Immunofluorescence_Processing/Processed/"

//Fill in replace function with the extension of your file

title = getTitle(); titlewoext = replace(title, ".czi", ""); 

//Set stack of interest

start = "3"
end = "7"

//Set colours of your channels

blue = "C1-" + titlewoext + "-1.czi";
red = "C2-" + titlewoext + "-1.czi";
green = "C3-" + titlewoext + "-1.czi";
grays = "C4-" + titlewoext + "-1.czi";

//Set Crop proportion

proportion = 3

//Set scale

scale = 50

//From now on the script will work automatically.
//Only if you want, commands related with brightness/contrast and filtering could be added

//Measure image dimensions to set the Crop

//Ask user to put the identificator of the crop

CropID = getString("Introduce crop ID", "");

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

//Project

selectWindow(""+blue+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");
selectWindow(""+red+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");
selectWindow(""+green+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");
selectWindow(""+grays+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");

//Rename after projections

blue = "MAX_" + blue;
red = "MAX_" + red;
green = "MAX_" +green;
grays = "MAX_" + grays;

run("Tile");

//If wanted, add commands to adjust brightness/contrast or filtering

//selectWindow(""+blue+""); setMinAndMax(1000, 35000);
//selectWindow(""+red+""); setMinAndMax(1500, 25000);run("Subtract Background...", "rolling=100");
//selectWindow(""+green+""); setMinAndMax(2000, 10000); run("Median...", "radius=2");
//selectWindow(""+grays+""); setMinAndMax(500, 60000);

waitForUser("adjust channels separately");

//Create composite channels c1=red, c2=green, c3=blue, c4=greys, c5=cyan, c6=magenta, c7=yellow.

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c3=["+blue+"] c1=["+red+"] keep ignore create");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_Composite.tif");

waitForUser("Adjust brightness/contrast in composite");

selectWindow(""+titlewoext+"_"+CropID+"_Composite.tif"); run("Split Channels");

//Rename colours

blue = "C3-" +titlewoext+"_"+CropID+"_Composite.tif";
red = "C1-" +titlewoext+"_"+CropID+"_Composite.tif";
green = "C2-" +titlewoext+"_"+CropID+"_Composite.tif";
grays = "C4-" +titlewoext+"_"+CropID+"_Composite.tif";

//Create different merges

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c3=["+blue+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_Merged_all.tif");

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergedWOdapi.tif");

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c3=["+blue+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergedapiWOred.tif");

run("Merge Channels...", "c4=["+grays+"] c3=["+blue+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergedapiWOgreen.tif");

run("Merge Channels...", "c2=["+green+"] c3=["+blue+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergedapiWOgrays.tif");

//Assign colours and save as RGB, remember to change them in run.

selectWindow(""+blue+"");run("Blue");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_blue.tif");

selectWindow(""+green+"");run("Green");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_green.tif");

selectWindow(""+grays+"");run("Grays");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_grays.tif");

selectWindow(""+red+"");run("Red");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_red.tif");

//Save merge with scales

selectWindow(""+titlewoext+"_"+CropID+"_Merged_all.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_Merged_all_wscale.tif");

selectWindow(""+titlewoext+"_"+CropID+"_MergedWOdapi.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergeWOdapi_wscale.tif");

selectWindow(""+titlewoext+"_"+CropID+"_MergedapiWOred.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergedapiWOred_wscale.tif");

selectWindow(""+titlewoext+"_"+CropID+"_MergedapiWOgreen.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergedapiWOgreen_wscale.tif");

selectWindow(""+titlewoext+"_"+CropID+"_MergedapiWOgrays.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_"+CropID+"_MergedapiWOgrays_wscale.tif");

selectWindow(""+titlewoext+"_"+CropID+"_Merged_all_wscale.tif");run("Copy to System");