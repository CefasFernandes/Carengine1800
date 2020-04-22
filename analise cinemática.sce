//projeto de motor 1800cc tricilindrico para carro
diam=10*(4*600/(%pi))^(1/3)// motor quadrado curso=diametro, diametro em mm
//começar analize cinemática
//medidas da biela 100mm de comprimento
q=[diam*cos(45*2*%pi/360)/4;diam*sin(45*2*%pi/360)/4;45*2*%pi/360;54.52;20;18.55*2*%pi/360;(diam/2)*cos(45*2*%pi/360)+100*cos(18.55*2*%pi/360);0]//chute inicial posição
//q=[x2,y2,theta2,x3,y3,theta3,x4,y4]
//ufa!! O HÁBITO É FOGO!! pensar que fazia isso rindo e contando piada...
corre=1// valor para corrigir método Newton
tolerancia=10^-15
maxit=120
ohm=750//valor para teste velocidade angular manter vmedia pistão abaixo de 24m/s
qv=[0;0;0;0;0;0;0;ohm]
passo=0.0001
tmax=3
t=0:passo:tmax
anap=zeros(length(q),length(t))
cont=0
for t=0:passo:tmax
cont=cont+1
//só lembrando residual ou restrição/ começo analise de posição
    for it=1:maxit
         residual=[q(1)-(diam/4)*cos(q(3));
              q(2)-(diam/4)*sin(q(3));
              q(1)+(diam/4)*cos(q(3))-q(4)+50*cos(q(6));
              q(2)+(diam/4)*sin(q(3))-q(5)+50*sin(q(6));
              q(7)-(diam/2)*cos(q(3))-100*cos(q(6));
              q(8)-(diam/2)*sin(q(3))-100*sin(q(6));
              q(3)-ohm*t
]
    jaco=[1,0,(diam/4)*sin(q(3)),0,0,0,0,0;
          0,1,-(diam/4)*cos(q(3)),0,0,0,0,0;
           1,0,-(diam/4)*sin(q(3)),-1,0,-50*cos(q(6)),0,0;
            0,1,-(diam/4)*cos(q(3)),0,-1,50*sin(q(6)),0,0;
            0,0,(diam/2)*sin(q(3)),0,0,100*sin(q(6)),1,0;
            0,0,-(diam/2)*cos(q(3)),0,0,-100*cos(q(6)),0,1;
             0,0,1,0,0,0,0,0]
    corre=jaco\residual
     
    q=q-corre
    if norm(corre)<=tolerancia
        break;
         end
        end
        anap(:,cont)=q;
//fim da analise de posição/ velocidade e aceleração sairão por diff numerico! posso ser tanto burro quanto sábido, mas funciona!!!
    end
anav=zeros(length(q),length(t)-1)
anac=zeros(length(q),length(t)-2)
for k=1:length(q)
anav(k,:)=diff(anap(k,:))/passo
anac(k,:)=diff(anav(k,:))/passo
end
