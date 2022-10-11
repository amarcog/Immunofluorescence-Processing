// Set your output folder

output = "/Users/amarco/Desktop/Immunofluorescence_Processing/Processed/"

//Fill in replace function with your file extension

title = getTitle();titlewoext = replace(title, ".czi", "");

//Set start and end of Z projection

start = "5"
end = "41"

//Set colours of your channels

blue = "C1-" + title;
red = "C2-" + title;
green = "C3-" + title;
grays = "C4-" + title;

//Set scale

scale = 200;

//From now on the script will run w/o changes
//Only if it is required, command lines related with adjustment 
//of brightness/contrast and filtering could be added

run("Split Channels");

//Project

selectWindow(""+blue+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");close(blue);
selectWindow(""+red+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");close(red);
selectWindow(""+green+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");close(green);
selectWindow(""+grays+"");run("Z Project...", "start="+start+" stop="+end+" projection=[Max Intensity]");close(grays);

//Rename after projections

blue = "MAX_" + blue;
red = "MAX_" + red;
green = "MAX_" + green;
grays = "MAX_" + grays;

run("Tile");

//Put colors

selectWindow(""+blue+"");run("Blue");
selectWindow(""+green+"");run("Green");
selectWindow(""+grays+"");run("Grays");
selectWindow(""+red+"");run("Red");

//Add commands in case you want to adjust brightness/contrast or filtering
//Next inactive lines include some example of these commands:

selectWindow(""+blue+""); //setMinAndMax(0, 50000);//run("Median...", "radius=2");//run("Subtract Background...", "rolling=50");
selectWindow(""+red+""); //run("Median...", "radius=2");//setMinAndMax(1000, 30000); 
selectWindow(""+green+""); //setMinAndMax(2000, 25000); run("Median...", "radius=2");//run("Subtract Background...", "rolling=100");
selectWindow(""+grays+""); //setMinAndMax(0, 45000); run("Median...", "radius=2"); //run("16-bit"); //run("Median...", "radius=2");//run("Subtract Background...", "rolling=100");

waitForUser("adjust channels separately");

//Create composite channels c1=red, c2=green, c3=blue, c4=greys, c5=cyan, c6=magenta, c7=yellow.

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c3=["+blue+"] c1=["+red+"] keep ignore create");
saveAs("Tiff", ""+output+""+titlewoext+"_Composite.tif");

waitForUser("Adjust brightness/contrast in composite");

selectWindow(""+titlewoext+"_Composite.tif"); run("Split Channels");

//Rename colours from composite

blue = "C3-" +titlewoext+ "_Composite.tif";
red = "C1-" +titlewoext+ "_Composite.tif";
green = "C2-" +titlewoext+ "_Composite.tif";
grays = "C4-" +titlewoext+ "_Composite.tif";

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c3=["+blue+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_Merged_all.tif");

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_Mergedgreengrays.tif");

run("Merge Channels...", "c2=["+green+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_Mergedgreenred.tif");

run("Merge Channels...", "c2=["+green+"] c3=["+blue+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_Mergedgreenblue.tif");

run("Merge Channels...", "c4=["+grays+"] c3=["+blue+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_Mergedgraysblue.tif");

run("Merge Channels...", "c3=["+blue+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_Mergedbluered.tif");

run("Merge Channels...", "c4=["+grays+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_Mergedgraysred.tif");

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_MergedWOdapi.tif");

run("Merge Channels...", "c2=["+green+"] c4=["+grays+"] c3=["+blue+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_MergedapiWOred.tif");

run("Merge Channels...", "c4=["+grays+"] c3=["+blue+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_MergedapiWOgreen.tif");

run("Merge Channels...", "c2=["+green+"] c3=["+blue+"] c1=["+red+"] keep ignore");
selectWindow("RGB");saveAs("Tiff", ""+output+""+titlewoext+"_MergedapiWOgrays.tif");

//Assign colours and save as RGB

selectWindow(""+blue+"");run("Blue");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_blue.tif");

selectWindow(""+green+"");run("Green");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_green.tif");

selectWindow(""+grays+"");run("Grays");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_grays.tif");

selectWindow(""+red+"");run("Red");run("RGB Color");
saveAs("Tiff", ""+output+""+titlewoext+"_red.tif");

//Save merge with scales

selectWindow(""+titlewoext+"_Merged_all.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_Merged_all_wscale.tif");

selectWindow(""+titlewoext+"_MergedWOdapi.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_MergeWOdapi_wscale.tif");

selectWindow(""+titlewoext+"_MergedapiWOred.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_MergedapiWOred_wscale.tif");

selectWindow(""+titlewoext+"_MergedapiWOgreen.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_MergedapiWOgreen_wscale.tif");

selectWindow(""+titlewoext+"_MergedapiWOgrays.tif");height = getHeight();
run("Scale Bar...", "width="+scale+" height="+height*0.02+" font=29 color=White background=None location=[Lower Right] hide");
saveAs("Tiff", ""+output+""+titlewoext+"_MergedapiWOgrays_wscale.tif");

//Generate montage.

run("Concatenate...", "  title=[Stack] image1=["+titlewoext+"_blue.tif] image2=["+titlewoext+"_green.tif] image3=["+titlewoext+"_grays.tif]  image4=["+titlewoext+"_red.tif] image5=["+titlewoext+"_Merged_all_wscale.tif]")
run("Make Montage...", "columns=4 rows=1 first=2 last=5");
selectWindow("Montage");
saveAs("Tiff", ""+output+""+titlewoext+"_Montage.tif");
