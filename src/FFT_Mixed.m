function F1 = FFT_Mixed(V,F,M,locationx,locationy)
ft = @(U) fftshift(fft2(U));
ift = @(U) real(ifft2(ifftshift(U)));
V1 = zeros(size(F));
M1 = zeros(size(F));
S = size(V);
V1(1:S(1),1:S(2)) = V;
M1(1:S(1),1:S(2)) = M;
V1 = circshift(V1,[locationy - 1,locationx - 1]);
M1 = circshift(M1,[locationy - 1,locationx - 1]);
Vg = [V1 V1(:,end:-1:1)]; Vg = [Vg;Vg(end:-1:1,:)];
F1 = [F F(:,end:-1:1)]; F1 = [F1;F1(end:-1:1,:)];
S = size(F1);
[Jc,Ic] = meshgrid(1:S(2),1:S(1));
j0 = S(2)/2 + 1;
i0 = S(1)/2 + 1;
Jc = Jc - j0;
Ic = Ic - i0;
Vgradientx = ift(1i * 2 * pi/S(2) * Jc .* ft(Vg));
Vgradienty = ift(1i * 2 * pi/S(1) * Ic .* ft(Vg));
Vgradientx = Vgradientx(1:S(1)/2,1:S(2)/2);
Vgradienty = Vgradienty(1:S(1)/2,1:S(2)/2);
Fgradientx = ift(1i * 2 * pi/S(2) * Jc .* ft(F1));
Fgradienty = ift(1i * 2 * pi/S(1) * Ic .* ft(F1));
Fgradientx = Fgradientx(1:S(1)/2,1:S(2)/2);
Fgradienty = Fgradienty(1:S(1)/2,1:S(2)/2);
S = size(Fgradientx);
for i = 1:S(1)
    for j = 1:S(2)
        if M1(i,j) == 0
            continue;
        else
            if Fgradientx(i,j)^2 + Fgradienty(i,j)^2 < Vgradientx(i,j)^2 + Vgradienty(i,j)^2
                Fgradientx(i,j) = Vgradientx(i,j);
                Fgradienty(i,j) = Vgradienty(i,j);
            end
        end
    end
end

Gx = [Fgradientx -Fgradientx(:,end:-1:1)]; Gx = [Gx;Gx(end:-1:1,:)];
Gy = [Fgradienty;-Fgradienty(end:-1:1,:)]; Gy = [Gy Gy(:,end:-1:1)];
S = size(Gx);
[wx,wy] = meshgrid(1:S(2),1:S(1));
wx0 = S(2)/2 + 1;
wy0 = S(1)/2 + 1;
wx = wx - wx0;
wy = wy - wy0;
F1 = ((1i * 2 * pi * wx/S(2)).*ft(Gx) + (1i * 2 * pi * wy/S(1)).*ft(Gy)) ./ ((1i * 2 * pi * wx/S(2)).^2 + (1i * 2 * pi * wy/S(1)).^2);
F1(wy0,wx0) = 0;
F1 = ift(F1);
F1 = F1(1:S(1)/2,1:S(2)/2);
FO = F .* (1 - M1);
F1O = F1 .* (1 - M1);
delta1 = (sum(sum(FO)) - sum(sum(F1O))) / sum(sum(1 - M1));
F1 = F1 + delta1;
end