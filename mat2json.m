function mat2json(inputdir, outputdir)
    clear;
    dirs = dir([inputdir, '*.mat']);
    mkdir(outputdir);
    for i = 1:size(dirs)
        disp(i);
        data = load([inputdir, dirs(i).name]);
        mfile = fopen([outputdir, dirs(i).name(1:end-4),'.json'], 'w');
        fprintf(mfile, '%s', jsonencode(data));
        fclose(mfile);
    end
end
