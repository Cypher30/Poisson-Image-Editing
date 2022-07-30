function poisson_editing_FFT(source,destination,mask,filename,rangexl,rangexr,rangeyl,rangeyu,locationx,locationy)
figure1 = imread(source);
figure2 = imread(destination);
figure3 = imread(mask);
figure(1);
subplot(2,2,1);
imshow(figure1);
subplot(2,2,2);
imshow(figure2);
subplot(2,2,3);
imshow(figure3(rangeyl:rangeyu,rangexl:rangexr,:));
figure3(figure3 < 255) = 0;
figure3(figure3 == 255) = 1;


V1 = figure1(rangeyl:rangeyu,rangexl:rangexr,1);
V2 = figure1(rangeyl:rangeyu,rangexl:rangexr,2);
V3 = figure1(rangeyl:rangeyu,rangexl:rangexr,3);
V1 = double(V1);
V2 = double(V2);
V3 = double(V3);
M = figure3(rangeyl:rangeyu,rangexl:rangexr,1);


figure2(:,:,1) = uint8(FFT(V1,double(figure2(:,:,1)),M,locationx,locationy));
figure2(:,:,2) = uint8(FFT(V2,double(figure2(:,:,2)),M,locationx,locationy));
figure2(:,:,3) = uint8(FFT(V3,double(figure2(:,:,3)),M,locationx,locationy));


subplot(2,2,4);
imshow(figure2);
imwrite(figure2,filename);
end