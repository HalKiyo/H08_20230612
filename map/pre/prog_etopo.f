        program prog_etopo
c
        implicit none
c
        integer   i0l
        integer   n0l
        parameter (n0l=233280000)
        real      r1dat(n0l)
        character*128 c0ifname
        character*128 c0ofname
        integer i0cnt
        integer i0lmin
        integer i0lmax
        integer i0y
c
        call getarg(1,c0ifname)
        call getarg(2,c0ofname)
c
        open(15,file=c0ifname)
        read(15,*) (r1dat(i0l),i0l=1,n0l)
        close(15)
c
        i0cnt=1
        open(16,file=c0ofname,access='DIRECT',recl=360*60*4)
        do i0y=180*60,1,-1
            i0lmin=(i0y-1)*360*60+1
            i0lmax=i0y*360*60
            write(16,rec=i0cnt) (r1dat(i0l),i0l=i0lmin,i0lmax)
            i0cnt=i0cnt+1
        end do
        close(16)
c
        end
