%plots over fit of the signal

load('signaloverfit.mat')
timestamps_ordered_sin = timestamps_ordered(1):0.001:timestamps_ordered(end);
my_idx = 225 -HrEstStruct.hrLowerBound;
curve = models.projVector(:,my_idx)'*measures_ordered;
sinusoid_draw = sin(models.omega(my_idx)*timestamps_ordered_sin+models.phi(my_idx))+models.a0(my_idx)+models.a1(my_idx)*timestamps_ordered_sin;
sinusoid = sin(models.omega(my_idx)*timestamps_ordered+models.phi(my_idx))+models.a0(my_idx)+models.a1(my_idx)*timestamps_ordered;

h_f = figure;
% subplot(2,1,1);

plot(timestamps_ordered, curve);
hold on;
plot(timestamps_ordered_sin, sinusoid_draw,'r');
plot(timestamps_ordered, curve,'o');
% title(['\epsilon = ' num2str(sum((sinusoid-curve).^2))],'FontSize', 20);

hold off;

my_idx = 73 -HrEstStruct.hrLowerBound;
curve = models.projVector(:,my_idx)'*measures_ordered;
sinusoid_draw = sin(models.omega(my_idx)*timestamps_ordered_sin+models.phi(my_idx))+models.a0(my_idx)+models.a1(my_idx)*timestamps_ordered_sin;
sinusoid = sin(models.omega(my_idx)*timestamps_ordered+models.phi(my_idx))+models.a0(my_idx)+models.a1(my_idx)*timestamps_ordered;
% subplot(2,1,2);
h_f = figure;
plot(timestamps_ordered, curve);
hold on;
plot(timestamps_ordered_sin, sinusoid_draw,'r');
plot(timestamps_ordered, curve,'o');
% title(['\epsilon = ' num2str(sum((sinusoid-curve).^2))],'FontSize',20);
hold off;
