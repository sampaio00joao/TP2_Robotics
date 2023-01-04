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
%% Operações Morfológicas
matrix = strel('square',15); % elemento estruturante
closedIm = imclose(bw,matrix); % operação de fecho
filledIm = imfill(closedIm,'holes'); % preenchimento do interior do Sinal
%% Extração da área da folha
stats =  regionprops(filledIm,'MajorAxisLength','MinorAxisLength','PixelIdxList','Area'); % retirar as areas de todos os blobs detetados na imagem
% eliminar blobs indesejados / Ruído
[maxValue,index] = max([stats.Area]); % guarda a área do maior blob / corresponde ao objeto 
majorAxis = max([stats.MajorAxisLength]);
minorAxis = max([stats.MinorAxisLength]);
[rw col] = size(stats);
for i=1:rw
    if (i~=index)
        filledIm(stats(i).PixelIdxList) = 0; % remove os blobs que correspondem ao ruído / área menor
    end
end
%% Multiplicar as imagens
multi = uint8(filledIm); % Converter para 8bits
imMultiplied = im.*multi; % Multiplicar a Imagem Binaria com a Original
figure, imshow(imMultiplied)
%% Aplicar Filtro Vermelho
bw2 = createMaskRed(imMultiplied);
figure, imshow(bw2)
%% Operações Morfológicas
matrix = strel('square',10); % elemento estruturante
closedIm = imclose(bw2,matrix); % operação de fecho
filledIm = imfill(closedIm,'holes'); % preenchimento do interior do Sinal
figure, imshow(filledIm)
%% Eliminar blobs de ruído
stats =  regionprops(filledIm,'PixelIdxList','Area'); % retirar as areas de todos os blobs detetados na imagem
Area = cat(1,stats.Area);
% eliminar blobs indesejados / Ruído
[maxValue,index] = max([stats.Area]); % guarda a área do maior blob / corresponde ao objeto 
[rw col]= size(stats);
for i=1:rw
    if (i~=index)
        filledIm(stats(i).PixelIdxList) = 0; % remove os blobs que correspondem ao ruído / área menor
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
%% Calcular posição 4.5cm base á ponta da folha 
imSize = size(im);
workAreaX = (imSize(1) - minorAxis) - minorAxis; 
workAreaY = (imSize(2) - majorAxis) - majorAxis;
locationX = workAreaX
locationY = workAreaY

