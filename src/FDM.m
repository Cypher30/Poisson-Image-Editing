function V1 = FDM(V,F,M,BXL,BXR,BYL,BYU)
S = size(V);
V1 = zeros(S(1),S(2));
V1(2:S(1) - 1,1) = BXL;
V1(2:S(1) - 1,S(2)) = BXR;
V1(1,2:S(2) - 1) = BYL;
V1(S(1),2:S(2) - 1) = BYU;
V1(2:S(1) - 1,2:S(2) - 1) = V(2:S(1) - 1,2:S(2) - 1);
Vgradientx = zeros(S(1),S(2));
Vgradienty = zeros(S(1),S(2));
VLaplacian = zeros(S(1) - 2,S(2) - 2);
for i = 1:S(1) - 2
    for j = 1:S(2) - 2
        if M(i + 1,j + 1) == 0
            Vgradientx(i + 1,j + 1) = (F(i + 1,j + 2) - F(i + 1,j))/2;
            Vgradienty(i + 1,j + 1) = (F(i,j + 1) - F(i + 2,j + 1))/2;
            V1(i + 1,j + 1) = F(i + 1,j + 1);
        else
            Vgradientx(i + 1,j + 1) = (V(i + 1,j + 2) - V(i + 1,j))/2;
            Vgradienty(i + 1,j + 1) = (V(i,j + 1) - V(i + 2,j + 1))/2;
        end
    end
end
for i = 2:S(1) - 1
    Vgradientx(i,1) = F(i,2) - F(i,1);
    Vgradienty(i,1) = (F(i - 1,1) - F(i + 1,1))/2;
    Vgradientx(i,S(2)) = F(i,S(2)) - F(i,S(2) - 1);
    Vgradienty(i,S(2)) = (F(i - 1,S(2)) - F(i + 1,S(2)))/2;
end
for j = 2:S(2) - 1
    Vgradientx(1,j) = (F(1,j + 1) - F(1,j - 1))/2;
    Vgradienty(1,j) = F(1,j) - F(2,j);
    Vgradientx(S(1),j) = (F(S(1),j + 1) - F(S(1),j - 1))/2;
    Vgradienty(S(1),j) = F(S(1) - 1,j) - F(S(1),j);
end
for i = 1:S(1) - 2
    for j = 1:S(2) - 2
        VLaplacian(i,j) = (Vgradientx(i + 1,j + 2) - Vgradientx(i + 1,j))/2 + (Vgradienty(i,j + 1) - Vgradienty(i + 2,j + 1))/2;
    end
end
Vtemp = V1;
while 1
    for i = 2:S(1) - 1
        if mod(i,2) == 0
            for j = 1:ceil((S(2) - 2)/2)
                V1(i,2 * j) = 1/4 * (V1(i - 1,2 * j) + V1(i + 1,2 * j) + V1(i,2 * j - 1) + V1(i,2 * j + 1) - VLaplacian(i - 1,2 * j - 1));
            end
        else
            for j = 1:floor((S(2) - 2)/2)
                V1(i,2 * j + 1) = 1/4 *(V1(i - 1,2 * j + 1) + V1(i + 1,2 * j + 1) + V1(i,2 * j) + V1(i,2 * j + 2) - VLaplacian(i - 1, 2 * j));
            end
        end
    end
    for i = 2:S(1) - 1
        if mod(i,2) == 1
            for j = 1:ceil((S(2) - 2)/2)
                V1(i,2 * j) = 1/4 * (V1(i - 1,2 * j) + V1(i + 1,2 * j) + V1(i,2 * j - 1) + V1(i,2 * j + 1) - VLaplacian(i - 1,2 * j - 1));
            end
        else
            for j = 1:floor((S(2) - 2)/2)
                V1(i,2 * j + 1) = 1/4 *(V1(i - 1,2 * j + 1) + V1(i + 1,2 * j + 1) + V1(i,2 * j) + V1(i,2 * j + 2) - VLaplacian(i - 1, 2 * j));
            end
        end
    end
    if norm(Vtemp - V1) < 10^(-4)
        break;
    end
    Vtemp = V1;
end
V1 = V1(2:S(1) - 1,2:S(2) - 1);
end