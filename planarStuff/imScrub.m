function rlPosition = imScrub(mixedPosition)

% removes any imaginary numbers leaving only real solutions

X = double(mixedPosition.x);
Y = double(mixedPosition.y);

mask = ~any(imag(X), 2) | ~any(imag(Y), 2);

rlPosition.x = X(mask)';
rlPosition.y = Y(mask)';
end