# nohup mpiexec -np 24 ./ ./$lv1_executable$ $lv1_infile_local$ 

echo $lv4_executable$

# format for mpiexec: mpiexec -np <np> <filename_to_execute> <infile_local> > logfile.log 

mpiexec -np $np$ $lv4_executable$ $lv4_infile_local$ 2>&1 | tee $lv4_logfile_local$
