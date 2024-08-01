function [ cal_file_name ] = writeEPIDCalFactor(output_dir,machine,cal_struct)
%Write EPID calibration factor to a file called EPID_CALIBRATION.mat.
%   Arguments: Input:  output_dir--the output directory for calibration files.
%                      machine-the name of the machine.
%              Output: cal_file_name--the name of calibration.
%

%tmp1=fullfile(output_dir,'EPID_CALIBRATION.mat');
tmp1=output_dir; % cal file with full path.

%final_date=cal_struct.date;
if exist(tmp1,'file')


    load(tmp1);

    vars=whos('-file',tmp1);

    % M1 block code

    if strcmp(machine,'M1')


        if ~ismember('M1_CAL',{vars.name})

            M1_CAL(1).machine_name=cal_struct.machine_name;

            M1_CAL(1).cal_factor=cal_struct.cal_factor;

            M1_CAL(1).physicist=cal_struct.physicist;

            M1_CAL(1).date=cal_struct.date;

            M1_CAL(1).cal_file=cal_struct.cal_file;


            save(tmp1,'M1_CAL','-append');
        else

            tmp2=length(M1_CAL);
            M1_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            M1_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            M1_CAL(tmp2+1).physicist=cal_struct.physicist;

            M1_CAL(tmp2+1).date=cal_struct.date;

            M1_CAL(tmp2+1).cal_file=cal_struct.cal_file;

            save(tmp1,'M1_CAL','-append');

        end


        cal_file_name=tmp1;

    end

    % m2 block code

    if strcmp(machine,'M2')



        if ~ismember('M2_CAL',{vars.name})

            M2_CAL(1).machine_name=cal_struct.machine_name;

            M2_CAL(1).cal_factor=cal_struct.cal_factor;

            M2_CAL(1).physicist=cal_struct.physicist;

            M2_CAL(1).date=cal_struct.date;

            M2_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(M2_CAL);
            M2_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            M2_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            M2_CAL(tmp2+1).physicist=cal_struct.physicist;

            M2_CAL(tmp2+1).date=cal_struct.date;

            M2_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'M2_CAL','-append');

        cal_file_name=tmp1;

    end

    % M3 block code

    if strcmp(machine,'M3')


        if ~ismember('M3_CAL',{vars.name})

            M3_CAL(1).machine_name=cal_struct.machine_name;

            M3_CAL(1).cal_factor=cal_struct.cal_factor;

            M3_CAL(1).physicist=cal_struct.physicist;

            M3_CAL(1).date=cal_struct.date;

            M3_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(M3_CAL);

            M3_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            M3_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            M3_CAL(tmp2+1).physicist=cal_struct.physicist;

            M3_CAL(tmp2+1).date=cal_struct.date;

            M3_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'M3_CAL','-append');

        cal_file_name=tmp1;

    end


    % M4 block code

    if strcmp(machine,'M4')



        if ~ismember('M4_CAL',{vars.name})
            M4_CAL(1).machine_name=cal_struct.machine_name;

            M4_CAL(1).cal_factor=cal_struct.cal_factor;

            M4_CAL(1).physicist=cal_struct.physicist;

            M4_CAL(1).date=cal_struct.date;

            M4_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(M4_CAL);
            M4_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            M4_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            M4_CAL(tmp2+1).physicist=cal_struct.physicist;

            M4_CAL(tmp2+1).date=cal_struct.date;

            M4_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'M4_CAL','-append');

        cal_file_name=tmp1;

    end


    % M5 block code

    if strcmp(machine,'M5')


        if ~ismember('M5_CAL',{vars.name})

            M5_CAL(1).machine_name=cal_struct.machine_name;

            M5_CAL(1).cal_factor=cal_struct.cal_factor;

            M5_CAL(1).physicist=cal_struct.physicist;

            M5_CAL(1).date=cal_struct.date;

            M5_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(M5_CAL);
            M5_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            M5_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            M5_CAL(tmp2+1).physicist=cal_struct.physicist;

            M5_CAL(tmp2+1).date=cal_struct.date;

            M5_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'M5_CAL','-append');

        cal_file_name=tmp1;

    end

    if strcmp(machine,'M7')


        if ~ismember('M7_CAL',{vars.name})

            M7_CAL(1).machine_name=cal_struct.machine_name;

            M7_CAL(1).cal_factor=cal_struct.cal_factor;

            M7_CAL(1).physicist=cal_struct.physicist;

            M7_CAL(1).date=cal_struct.date;

            M7_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(M7_CAL);
            M7_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            M7_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            M7_CAL(tmp2+1).physicist=cal_struct.physicist;

            M7_CAL(tmp2+1).date=cal_struct.date;

            M7_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'M7_CAL','-append');

        cal_file_name=tmp1;

    end


    % L1 block



    if strcmp(machine,'L1')


        if ~ismember('L1_CAL',{vars.name})

            L1_CAL(1).machine_name=cal_struct.machine_name;

            L1_CAL(1).cal_factor=cal_struct.cal_factor;

            L1_CAL(1).physicist=cal_struct.physicist;

            L1_CAL(1).date=cal_struct.date;

            L1_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(L1_CAL);
            L1_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            L1_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            L1_CAL(tmp2+1).physicist=cal_struct.physicist;

            L1_CAL(tmp2+1).date=cal_struct.date;

            L1_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'L1_CAL','-append');

        cal_file_name=tmp1;

    end

    %  L2



    if strcmp(machine,'L2')


        if ~ismember('L2_CAL',{vars.name})

            L2_CAL(1).machine_name=cal_struct.machine_name;

            L2_CAL(1).cal_factor=cal_struct.cal_factor;

            L2_CAL(1).physicist=cal_struct.physicist;

            L2_CAL(1).date=cal_struct.date;

            L2_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(L2_CAL);
            L2_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            L2_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            L2_CAL(tmp2+1).physicist=cal_struct.physicist;

            L2_CAL(tmp2+1).date=cal_struct.date;

            L2_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'L2_CAL','-append');

        cal_file_name=tmp1;

    end

    % L3


    if strcmp(machine,'L3')


        if ~ismember('L3_CAL',{vars.name})

            L3_CAL(1).machine_name=cal_struct.machine_name;

            L3_CAL(1).cal_factor=cal_struct.cal_factor;

            L3_CAL(1).physicist=cal_struct.physicist;

            L3_CAL(1).date=cal_struct.date;

            L3_CAL(1).cal_file=cal_struct.cal_file;


        else

            tmp2=length(L3_CAL);
            L3_CAL(tmp2+1).machine_name=cal_struct.machine_name;

            L3_CAL(tmp2+1).cal_factor=cal_struct.cal_factor;

            L3_CAL(tmp2+1).physicist=cal_struct.physicist;

            L3_CAL(tmp2+1).date=cal_struct.date;

            L3_CAL(tmp2+1).cal_file=cal_struct.cal_file;

        end

        save(tmp1,'L3_CAL','-append');

        cal_file_name=tmp1;

    end




    %%



else


    if strcmp(machine,'M1')

        M1_CAL=cal_struct;

        save(tmp1,'M1_CAL');

        cal_file_name=tmp1;

    end


    if strcmp(machine,'M2')

        M2_CAL=cal_struct;

        save(tmp1,'M2_CAL');

        cal_file_name=tmp1;

    end

    if strcmp(machine,'M3')

        M3_CAL=cal_struct;

        save(tmp1,'M3_CAL');

        cal_file_name=tmp1;

    end


    if strcmp(machine,'M4')

        M4_CAL=cal_struct;

        save(tmp1,'M4_CAL');

        cal_file_name=tmp1;

    end

    if strcmp(machine,'M5')

        M5_CAL=cal_struct;

        save(tmp1,'M5_CAL');

        cal_file_name=tmp1;

    end


    if strcmp(machine,'M7')

        M7_CAL=cal_struct;

        save(tmp1,'M7_CAL');

        cal_file_name=tmp1;

    end

    if strcmp(machine,'L1')

        L1_CAL=cal_struct;

        save(tmp1,'L1_CAL');

        cal_file_name=tmp1;

    end

    if strcmp(machine,'L2')

        L2_CAL=cal_struct;

        save(tmp1,'L2_CAL');

        cal_file_name=tmp1;

    end


    if strcmp(machine,'L3')

        L3_CAL=cal_struct;

        save(tmp1,'L3_CAL');

        cal_file_name=tmp1;

    end



end



end

