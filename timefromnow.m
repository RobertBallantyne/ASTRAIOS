function dt = timefromnow(epoch)

epoch_datetime = datetime(epoch, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');

now = datetime('Now');

dt = seconds(now-epoch_datetime);

end