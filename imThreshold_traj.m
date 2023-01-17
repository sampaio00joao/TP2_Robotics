function [pos,objPosX,objPosY] = imThreshold_traj()
    %% Setup the camera and take a picture
    vid = webcam('HD Webcam');
    im = snapshot(vid);
    %% Red Filter
    bw2 = createMaskRed(im);
    figure, imshow(bw2)
    %% Image treatment
    matrix = strel('square',10); % kernel
    closedIm = imclose(bw2,matrix); % close
    filledIm = imfill(closedIm,'holes'); % fill
    %% Eliminate noise
    stats =  regionprops(filledIm,'PixelIdxList','Area'); % all the blobs become objects
    Area = cat(1,stats.Area); % get the area
    [maxValue,index] = max([stats.Area]); % Saves the biggest area / the object
    [rw col]= size(stats);
    for i=1:rw
        if (i~=index)
            filledIm(stats(i).PixelIdxList) = 0; % removes every object with a lesser area
        end
    end
    %% Object Quantity
    object = bwconncomp(filledIm);
    totalObj = object.NumObjects
    %% Choose position
    % Count the pixels in the image
    object = regionprops(filledIm, 'centroid','BoundingBox','Circularity','Area'); % Image Centroid
    objectArea = cat(1,object.Area); % object area
    centroid = cat(1,object.Centroid); 
    centroid(:,:)
    pause(1);
    hold on
    plot(centroid(:,1), centroid(:,2), 'b*'); % mark the centroid on the figure
    %% Calcular posição 4.5cm base á ponta da folha 
    imSize = size(im) % get the image size
    % A4 paper --> 21cm - 29.7
    objPosX = ((centroid(:,1)*21) / imSize(:,1))-1 % x
    objPosY = ((centroid(:,2)*29.7) / imSize(:,2))-2.5 % y
    pos = 3; % go to the random position
end
