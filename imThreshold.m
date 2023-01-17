function [pos] = imThreshold()
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
    cc = bwconncomp(filledIm);
    totalObj = cc.NumObjects;
    %% Choose position
    % Count the pixels in the image
    stats =  regionprops(filledIm,'Centroid'); % Image Centroid
    middleColumn = stats.Centroid(2); % Imaginary vertical line cutting the image in 2 pieces
    leftHalf = floor(nnz(filledIm(:,1:middleColumn))); % Count the pixels on the left
    rightHalf = floor(nnz(filledIm(:,middleColumn+1:end))); % Count the pixels on the right
    if leftHalf < rightHalf 
        pos = 1; % go to position 1
        disp("Right") 
    else 
        pos = 2; % go to position 1
        disp("Left") 
    end
end

