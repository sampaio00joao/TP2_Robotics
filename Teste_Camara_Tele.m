clear all; close all; clc 
%% SetUp
%Instalar a aplicacao droidcam da appstore
mycam = ipcam('http://100.65.178.26:4747/video'); % Colocar na consola 1x
preview(mycam)
%% Tirar e Guardar Foto
pause(10)
im = snapshot(mycam);
imwrite(im,'CAM_PHOTO.jpg');
%% Aplicar Filtro Folha Branca
bw = createMaskWhiteHSV(im); 
%% Opera��es Morfol�gicas
matrix = strel('square',15); % elemento estruturante
closedIm = imclose(bw,matrix); % opera��o de fecho
filledIm = imfill(closedIm,'holes'); % preenchimento do interior do Sinal
%% Extra��o da �rea da folha
stats =  regionprops(filledIm,'MajorAxisLength','MinorAxisLength','PixelIdxList','Area'); % retirar as areas de todos os blobs detetados na imagem
% eliminar blobs indesejados / Ru�do
[maxValue,index] = max([stats.Area]); % guarda a �rea do maior blob / corresponde ao objeto 
majorAxis = max([stats.MajorAxisLength]);
minorAxis = max([stats.MinorAxisLength]);
[rw col] = size(stats);
for i=1:rw
    if (i~=index)
        filledIm(stats(i).PixelIdxList) = 0; % remove os blobs que correspondem ao ru�do / �rea menor
    end
end
%% Multiplicar as imagens
multi = uint8(filledIm); % Converter para 8bits
imMultiplied = im.*multi; % Multiplicar a Imagem Binaria com a Original
figure, imshow(imMultiplied)
%% Aplicar Filtro Vermelho
bw2 = createMaskRed(imMultiplied);
figure, imshow(bw2)
%% Opera��es Morfol�gicas
matrix = strel('square',10); % elemento estruturante
closedIm = imclose(bw2,matrix); % opera��o de fecho
filledIm = imfill(closedIm,'holes'); % preenchimento do interior do Sinal
figure, imshow(filledIm)
%% Eliminar blobs de ru�do
stats =  regionprops(filledIm,'PixelIdxList','Area'); % retirar as areas de todos os blobs detetados na imagem
Area = cat(1,stats.Area);
% eliminar blobs indesejados / Ru�do
[maxValue,index] = max([stats.Area]); % guarda a �rea do maior blob / corresponde ao objeto 
[rw col]= size(stats);
for i=1:rw
    if (i~=index)
        filledIm(stats(i).PixelIdxList) = 0; % remove os blobs que correspondem ao ru�do / �rea menor
    end
end
%% Plot das imagens
imshow(filledIm);
title('Imfill');
%% Etiquetar
cc = bwconncomp(filledIm);
totalObj = cc.NumObjects
%% Centroide
object = regionprops(filledIm, 'centroid','BoundingBox','Circularity','Area');
objectArea = cat(1,object.Area);
centroid = cat(1,object.Centroid);
centroid(:,:)
pause(1);
hold on
plot(centroid(:,1), centroid(:,2), 'b*');
%% Calcular posi��o 4.5cm base � ponta da folha 
imSize = size(im);
workAreaX = (imSize(1) - minorAxis) - minorAxis; 
workAreaY = (imSize(2) - majorAxis) - majorAxis;
locationX = workAreaX
locationY = workAreaY

