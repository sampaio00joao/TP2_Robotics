function [pos] = imThreshold()
    vid = webcam('HD Webcam');
%     preview(vid);
    im = snapshot(vid);
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
    cc = bwconncomp(filledIm);
    totalObj = cc.NumObjects;

    % Saber a Orientacao da Seta
    stats =  regionprops(filledIm,'Centroid'); % Centro do Objeto
    middleColumn = stats.Centroid(2); % Define que o a Linha de Separacao para Contar Pixeis vai a Posicao da Coordenada X do Centroid
    leftHalf = floor(nnz(filledIm(:,1:middleColumn))); % Contar os Pixeis a Esqueda da Coluna Central
    rightHalf = floor(nnz(filledIm(:,middleColumn+1:end))); % Contar os Pixeis a Direita da Coluna Central
    if leftHalf < rightHalf 
        pos = 1;
        disp("Direita")
    else 
        pos = 2;
        disp("Esquerda") 
    end
end

