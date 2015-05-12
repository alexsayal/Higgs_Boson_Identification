function [mean_dist]=euclidean_dist(center,vect)

d=zeros(length(vect),1);

for i=1:length(vect)
    d(i,1)=pdist([center;vect(i,:)],'euclidean');
end

mean_dist=mean(d);

end
    