function [objPosX,objPosY] = imThreshold_traj()
%     vid = webcam('HD Webcam');
%     preview(vid);
%     im = snapshot(vid);
    im = imread('CAM_PHOTO.jpg');
    figure, imshow(im)
    %% Aplicar Filtro Vermelho
    bw2 = createMaskRed(im);
    figure, imshow(bw2)
    %% Operações Morfológicas
    matrix = strel('square',10); % elemento estruturante
    closedIm = imclose(bw2,matrix); % operação de fecho
    filledIm = imfill(closedIm,'holes'); % preenchimento do interior do Sinal
    % figure, imshow(filledIm)
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
    % imshow(filledIm);
    % title('Imfill');
    %% Etiquetar
    object = bwconncomp(filledIm);
%     totalObj = object.NumObjects

    %% Centroide
    object = regionprops(filledIm, 'centroid','BoundingBox','Circularity','Area');
    objectArea = cat(1,object.Area);
    centroid = cat(1,object.Centroid);
    centroid(:,:)
    pause(1);
    hold on
    plot(centroid(:,1), centroid(:,2), 'b*');
    %% Calcular posição 4.5cm base á ponta da folha 
    imSize = size(im)
    %Tamnaho da folha A4 --> 21cm - 29.7
    objPosX = (centroid(:,1)*21) / imSize(:,1) %Em cm
    objPosY = (centroid(:,2)*29.7) / imSize(:,2) %Em cm
end



