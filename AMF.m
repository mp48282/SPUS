clc
clear all
close all
warning off


[ImeSlike,PutanjaDoSlike] = uigetfile('*.png','Odaberite sliku za testiranje');
fullpathname = strcat(PutanjaDoSlike,ImeSlike);
Iin = imread(fullpathname); 
sum_posto = input('Unesite iznos postotka sol&papar šuma  :\n ');
shum = sum_posto/100;
[m,n,o] = size(Iin);
if o == 3
pocetna = (rgb2gray(Iin));
else
pocetna = (Iin);
end
zasumljena = imnoise(pocetna,'salt & pepper',shum)
zasumljena2 = (padarray(zasumljena,[3,3]))
[m1,n1] = size(zasumljena2);
filtrirana = zeros(m1,n1);
c1 = 0;
c2 = 0;
for i= 4: m1-3
for j = 4:n1-3
flag = 0;
for k = 3:2:7
s = (k-1)/2;
temp = double(zasumljena2(i-s:i+s,j-s:j+s));
Smed = median(temp(:));
Smin = min(temp(:));
Smax = max(temp(:));
A1 = Smed-Smin;
A2 = Smed-Smax;
if A1 > 0 && A2 < 0
flag = 1;
ss = s;
c1 = c1+1;
break;
end
end
if flag == 1
s= ss;
temp = zasumljena2(i-s:i+s,j-s:j+s);
Smed = median(temp(:));
Smin = min(temp(:));
Smax = max(temp(:));
Sij = zasumljena2(i,j);
B1 = Sij-Smin;
B2 = Sij-Smax;
if B1 > 0 && B2 < 0
filtrirana(i,j) = Sij;
else
filtrirana(i,j) = Smed;
c2 = c2+1;
end
end

end
end
clc;

filtrirana = filtrirana(4:end-3,4:end-3)
squaredError = (double(pocetna) - double(filtrirana)) .^ 2;
MSE = sum(sum(squaredError)) / (size(filtrirana,1) * size(filtrirana,2));
PSNR = 10 * log10( 256^2 / MSE);
fprintf('\n Kolicina dodanog suma je : %0.1f posto\n ', sum_posto);
fprintf('\n Peak-SNR  je : %0.2f \n', PSNR);

ImeSlike = ImeSlike(1:end-4);

subplot; imshow(uint8(zasumljena2)); title('Input image with Noise');
saveas(gcf,sprintf('%s_sum_%dposto.jpg', ImeSlike, sum_posto))
subplot; imshow(uint8(filtrirana)); title('Adaptive median filtared image');
saveas(gcf,sprintf('%s_filtar_%dposto.jpg', ImeSlike, sum_posto))

subplot 151; imshow(uint8(pocetna));title('Pocetna slika')
subplot 153; imshow(uint8(zasumljena2)); title('Zasumljena slika')
subplot 155; imshow(uint8(filtrirana)); title('Filtrirana adaptivnim medijan filtrom')

