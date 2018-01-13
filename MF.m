clc
clear all
close all
warning off

[ImeSlike,PutanjaDoSlike] = uigetfile('*.png','Odaberi sliku za testiranje');
fullpathname = strcat(PutanjaDoSlike,ImeSlike);
ucitana = imread(fullpathname);
sum_postoci = input('Unesi iznos sol&papar suma u postocima : \n ');
shum = sum_postoci/100;
[m,n,o] = size(ucitana)
if o == 3
pocetna = (rgb2gray(ucitana));
else
pocetna = (ucitana);
end
zasumljena = imnoise(pocetna,'salt & pepper',shum);
filtrirana = medfilt2(zasumljena,[3,3]);
if (size(pocetna) ~= size(filtrirana))
error('Velicina matrica je neregulatrna')
psnr_Value = NaN;
return;
elseif (pocetna == filtrirana)
disp('Slike su identicne: PSNR je beskonacan')
psnr_Value = Inf;
return;
else
maxValue = double(max(pocetna(:)));
mseImage = (double(pocetna) - double(filtrirana)) .^ 2;
[rows columns] = size(pocetna);
mse = sum(mseImage(:)) / (rows * columns)
psnr_Value = 10 * log10( 256^2 / mse)
RMSE = sqrt(mse)
end

ImeSlike = ImeSlike(1:end-4)
subplot; imshow(uint8(zasumljena)); title('Input image with Noise');
saveas(gcf,sprintf('%s_sum_%dposto.jpg', ImeSlike, sum_postoci))

subplot; imshow(uint8(filtrirana)); title('Adaptive median filtared image');
saveas(gcf,sprintf('%s_filtar_%dposto.jpg', ImeSlike, sum_postoci))

subplot 151; imshow(uint8(pocetna));title('Pocetna slika')
subplot 153; imshow(uint8(zasumljena)); title('Zasumljena slika')
subplot 155; imshow(uint8(filtrirana)); title('Filtrirana medijan filtrom')