function poisson_editing_Mixed_FDM(source,destination,mask,filename,rangexl,rangexr,rangeyl,rangeyu,locationx,locationy)
figure1 = imread(source);
figure2 = imread(destination);
figure3 = imread(mask);
figure(1);
subplot(2,2,1);
imshow(figure1);
subplot(2,2,2);
imshow(figure2);


V1 = figure1(rangeyl:rangeyu,rangexl:rangexr,1);
V2 = figure1(rangeyl:rangeyu,rangexl:rangexr,2);
V3 = figure1(rangeyl:rangeyu,rangexl:rangexr,3);
V1 = double(V1);
V2 = double(V2);
V3 = double(V3);
F1 = figure2(locationy:locationy + rangeyu - rangeyl,locationx:locationx + rangexr - rangexl,1);
F2 = figure2(locationy:locationy + rangeyu - rangeyl,locationx:locationx + rangexr - rangexl,2);
F3 = figure2(locationy:locationy + rangeyu - rangeyl,locationx:locationx + rangexr - rangexl,3);
F1 = double(F1);
F2 = double(F2);
F3 = double(F3);
M = figure3(rangeyl:rangeyu,rangexl:rangexr,1);


BXL1 = double(figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + 1,1));
BXL2 = double(figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + 1,2));
BXL3 = double(figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + 1,3));


BXR1 = double(figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + rangexr - rangexl - 1,1));
BXR2 = double(figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + rangexr - rangexl - 1,2));
BXR3 = double(figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + rangexr - rangexl - 1,3));

BYL1 = double(figure2(locationy + 1,locationx + 1:locationx + rangexr - rangexl - 1,1));
BYL2 = double(figure2(locationy + 1,locationx + 1:locationx + rangexr - rangexl - 1,2));
BYL3 = double(figure2(locationy + 1,locationx + 1:locationx + rangexr - rangexl - 1,3));


BYU1 = double(figure2(locationy + rangeyu - rangeyl - 1,locationx + 1:locationx + rangexr - rangexl - 1,1));
BYU2 = double(figure2(locationy + rangeyu - rangeyl - 1,locationx + 1:locationx + rangexr - rangexl - 1,2));
BYU3 = double(figure2(locationy + rangeyu - rangeyl - 1,locationx + 1:locationx + rangexr - rangexl - 1,3));


figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + 1:locationx + rangexr - rangexl - 1,1) = uint8(FDM_Mixed(V1,F1,M,BXL1,BXR1,BYL1,BYU1));
figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + 1:locationx + rangexr - rangexl - 1,2) = uint8(FDM_Mixed(V2,F2,M,BXL2,BXR2,BYL2,BYU2));
figure2(locationy + 1:locationy + rangeyu - rangeyl - 1,locationx + 1:locationx + rangexr - rangexl - 1,3) = uint8(FDM_Mixed(V3,F3,M,BXL3,BXR3,BYL3,BYU3));


subplot(2,2,3);
imshow(figure3(rangeyl:rangeyu,rangexl:rangexr,:));
subplot(2,2,4);
imshow(figure2);
imwrite(figure2,filename);
end