function [O1,O2,O3,O4,O5]=available_model(h_BR,h_B1,h_R1,h_R2,h_12,R0,rho)
  O5=0;
  if h_BR^2>=(2^(2*R0)-1)/rho
      O1=1;
  else
      O1=0;
  end
  if h_B1^2>=(2^(2*R0)-1)/rho
      O2=1;
  else
      O2=0;
  end
  if h_R1^2>=(2^R0-1)/rho&& h_R1^2<=(2^(2*R0)-1)/rho&&h_R2>=2^R0*(2^R0-1)/(rho-(2^R0-1)/h_R1^2) || h_R1^2>=(2^(2*R0)-1)/rho&&h_R2^2>=(2^R0-1)/(rho-2^R0*(2^R0-1)/h_R1^2)
      O3=1;
  else
      O3=0;
  end
  if h_12^2>=(2^R0-1)/rho
      O4=1;
  else
      O4=0;
  end
  if O1||O2||O3||O4==0%表示所有的链路的信道条件都不满足成功解码的条件
    O5=1;
  end
end
