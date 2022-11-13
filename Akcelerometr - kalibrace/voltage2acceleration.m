function [g,g_ref]=voltage2acceleration(u,u_ref)
    %Prevod napeti na zrychlenu [g]

    % Staticky namerene napeti pro +1g a -1g (mean ze signálu)
    down_mean = 2.1407; % -g
    up_mean = 2.9422; % +g

    % Kalibracni primka pro zkoumany senzor (ze statickych mereni gravitace)
    g=2/(up_mean-down_mean)*u-6.3417;

    % Pro referencni senzor 
    % smernice primky z katalogoveho listu; posuv aby sedelo pri +1g
    g_ref=u_ref/0.2-0.0042; 
end