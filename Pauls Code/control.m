function u = control(s_br, delw, w_bn, w_rn, w_rn_dot, L, controltype, K_I, Z)
        global K P I
        
        if controltype == 1
            u = -K*s_br - P*delw + I*(w_rn_dot-cross(w_bn,w_rn))+(tilde(w_bn)*I)*w_bn - L;
        end
        
        if controltype == 2
            u = -K*s_br - P*delw;
        end
        
        if controltype == 3
            u = -K*s_br - P*delw + I*(w_rn_dot-cross(w_bn,w_rn))+(tilde(w_bn)*I)*w_bn;
        end
        
        if controltype == 4
            u = -K*s_br - P*delw + I*(w_rn_dot-cross(w_bn,w_rn))+(tilde(w_bn)*I)*w_bn - P*K_I*Z;
        end
        
        if controltype == 5
            u = -K*s_br - P*delw + tilde(delw)*I*delw;
        end
        
        if controltype == 6
            u = -K*s_br - P*delw + I*(w_rn_dot-cross(w_bn,w_rn))+(tilde(w_bn)*I)*w_bn - L;
            
            if abs(u(1,1))>=26e3
                u(1,1) = 25e3*sign(u(1,1));
            end
            
            if abs(u(2,1))>=25e3
                u(2,1) = 25e3*sign(u(2,1));
            end
            
            if abs(u(3,1))>=25e3
                u(3,1) = 25e3*sign(u(3,1));
            end
             
        end
        
        if controltype == 7
            u = -tilde(w_bn)*I*w_bn + I*(-P*w_bn - (w_bn*transpose(w_bn) + ((4*K)/(1+norm(s_br)^2) - (norm(w_bn)^2)/2)*eye(3))*s_br);
        end
            
end