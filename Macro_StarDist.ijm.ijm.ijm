
input = "L:\\lmu_active1\\instruments\\Nano\\kakialek\\TH test\\3-11-2021-TH 10x test\\2022-03-15\\13\\TimePoint_1\\";
output = "L:\\lmu_active1\\users\\k\\kakialek\\StarDist\\2022-03-15\\";

// Small test data set.
input = "L:\\lmu_active1\\users\\k\\kakialek\\StarDist\\test\\data\\";
output = "L:\\lmu_active1\\users\\k\\kakialek\\StarDist\\test\\output\\";

// Uncomment these if you want to select the folders with GUI.
//input = getDirectory("Input directory");
//output = getDirectory("Output directory");

suffix = ".tif"

setBatchMode(false);
processFolder(input);

function processFolder(input) {
    print("Processing folder: " + input);
    list = getFileList(input);
    for (i = 0; i < list.length; i++) {
        if(File.isDirectory(list[i]))
            processFolder("" + input + list[i]);
        if(endsWith(list[i], suffix))
            processFile(input, output, list[i]);
    }
}
 
function processFile(input, output, file) {
	// skip thumbnail images
	if (matches(file, ".*thumb.*")) {
		print("Skipping file: " + file);
		return;
	}
	// only process DAPI (w1)
	if (!matches(file, ".*_w1.*")) {
		print("Skipping file: " + file);
		return;
	}
	
	print("Processing file: " + file);
    open(input + file);
    
    // StarDist parameters (these must be given as strings)
    percentileBottom = '4.0';
    percentileTop = '100.0';
    probThresh = '0.50';

    //cmd = "command=[de.csbdresden.stardist.StarDist2D], args=['input':'" + file + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'3.9999999999999996', 'percentileTop':'99.80000000000001', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Label Image', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]";
	cmd = "command=[de.csbdresden.stardist.StarDist2D], args=['input':'" + file + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'" + percentileBottom + "', 'percentileTop':'" + percentileTop + "', 'probThresh':'" + probThresh + "', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'true', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]";
	print(cmd);
    run("Command From Macro", cmd);
	//selectWindow("Label Image");
	
	if (false) {
		list = getList("image.titles");
  		if (list.length==0)
    		print("No image windows are open");
  		else {
     		print("Image windows:");
     		for (i=0; i<list.length; i++)
        		print("   "+list[i]);
  		}
 		print("");
 		print(nImages);
 
		close(file);
 		print(nImages);
	}
	
    // add stardist to filename
    file_out = file.replace(".tif","") + "_stardist.tif";
    // use channel number 8
    file_out = file_out.replace("_w1","_w8");
    print("Saving to: " + output + file_out);
    saveAs("TIFF", output+file_out);
    close("*");
    //run("Close All");
}