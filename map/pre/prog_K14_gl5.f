      program prog_WATCH_Albedo
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0lin
      integer           n0xin
      integer           n0yin
      integer           n0lout
      integer           n0xout
      integer           n0yout
      parameter        (n0lin=259200) 
      parameter        (n0xin=720) 
      parameter        (n0yin=360) 
      parameter        (n0lout=9331200) 
      parameter        (n0xout=4320) 
      parameter        (n0yout=2160) 
c
      character*128     c0l2xin
      character*128     c0l2yin
      integer           i1l2xin(n0lin)
      integer           i1l2yin(n0lin)
      character*128     c0l2xout
      character*128     c0l2yout
      integer           i1l2xout(n0lout)
      integer           i1l2yout(n0lout)
c index
      integer           i0l
      integer           i0x
      integer           i0y
      integer           ii0x
      integer           ii0y
c in    
      real              r1dat(n0lin)
      real              r2dat(n0xin,n0yin)
      character*128     c0dat
      real              id 
c out
      real              r1out(n0lout)
      real              r2out(n0xout,n0yout)
      character*128     c0out
c local
      real              r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6)then
        write(*,*) 'prog_hlf2gl5 c0l2xin c0l2yin c0l2xout c0l2yout'
        write(*,*) '                  c0dat   c0out'
        stop
      end if
c
      call getarg(1,c0l2xin)
      call getarg(2,c0l2yin)
      call getarg(3,c0l2xout)
      call getarg(4,c0l2yout)
      call getarg(5,c0dat)
      call getarg(6,c0out)
c
      call read_i1l2xy(
     $     n0lin,
     $     c0l2xin,c0l2yin,
     $     i1l2xin,i1l2yin)
      call read_i1l2xy(
     $     n0lout,
     $     c0l2xout,c0l2yout,
     $     i1l2xout,i1l2yout)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0lin,c0dat,r1dat)
c
      r1out=1.0E20
c
      do i0l=1,n0lin
        if(r1dat(i0l).eq.1.0E20)then
          r1dat(i0l)=0.0
        end if
      end do
c
      call conv_r1tor2(
     $     n0lin,n0xin,n0yin,i1l2xin,i1l2yin,
     $     r1dat,
     $     r2dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0y=1,n0yin
        do i0x=1,n0xin
          id=r2dat(i0x,i0y)
          ! left grid 
          ii0x=i0x-1
          ii0y=i0y
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin)
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6 -5 : i0x*6-3,  i0y*6 - 4 )=r2dat(i0x,i0y)
          end if 
          ! right grid 
          ii0x=i0x+1
          ii0y=i0y
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin)
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6 -3 : i0x*6,    i0y*6 - 4 )=r2dat(i0x,i0y)
          end if 
          ! upper grid 
          ii0x=i0x
          ii0y=i0y-1
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin)
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6 -3 , i0y*6 - 5 : i0y*6 -3 )=r2dat(i0x,i0y)
          end if 
          ! lower grid 
          ii0x=i0x
          ii0y=i0y-1
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin)
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6 -3 , i0y*6 - 3 : i0y*6    )=r2dat(i0x,i0y)
          end if
          !------------
          ! upper left corner grid 
          ii0x=i0x-1
          ii0y=i0y-1
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin)
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6 -5 ,  i0y*6 - 5 )=r2dat(i0x,i0y)
            r2out(i0x*6 -4 ,  i0y*6 - 4 )=r2dat(i0x,i0y)
            r2out(i0x*6 -3 ,  i0y*6 - 3 )=r2dat(i0x,i0y)
          end if 
          ! upper right corner grid 
          ii0x=i0x+1
          ii0y=i0y-1
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin)
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6     ,  i0y*6 - 5 )=r2dat(i0x,i0y)
            r2out(i0x*6 - 1 ,  i0y*6 - 4 )=r2dat(i0x,i0y)
            r2out(i0x*6 - 2 ,  i0y*6 - 4 )=r2dat(i0x,i0y)
            r2out(i0x*6 - 3 ,  i0y*6 - 3 )=r2dat(i0x,i0y)
          end if 
          ! lower left corner grid 
          ii0x=i0x-1
          ii0y=i0y+1
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin)
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6 - 5 , i0y*6     )=r2dat(i0x,i0y)
            r2out(i0x*6 - 5 , i0y*6 - 1 )=r2dat(i0x,i0y)
            r2out(i0x*6 - 4 , i0y*6 - 2 )=r2dat(i0x,i0y)
            r2out(i0x*6 - 3 , i0y*6 - 3 )=r2dat(i0x,i0y)
          end if 
          ! lower grid 
          ii0x=i0x
          ii0y=i0y-1
          call ixy2iixy(ii0x,ii0y, n0xin, n0yin) 
          if (r2dat(ii0x,ii0y) .eq. id) then
            r2out(i0x*6     , i0y*6     )=r2dat(i0x,i0y)
            r2out(i0x*6 - 5 , i0y*6 - 5 )=r2dat(i0x,i0y)
            r2out(i0x*6 - 4 , i0y*6 - 4 )=r2dat(i0x,i0y)
            r2out(i0x*6 - 3 , i0y*6 - 3 )=r2dat(i0x,i0y)  
          end if  
          !r2out(i0x*2,  i0y*2  )=r2dat(i0x,i0y)
          !r2out(i0x*2-1,i0y*2  )=r2dat(i0x,i0y)
          !r2out(i0x*2,  i0y*2-1)=r2dat(i0x,i0y)
          !r2out(i0x*2-1,i0y*2-1)=r2dat(i0x,i0y)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r2tor1(
     $     n0lout,n0xout,n0yout,i1l2xout,i1l2yout,
     $     r2out,
     $     r1out)        
      call wrte_binary(n0lout,r1out,c0out)
c
      end
!***************************************************   
      function roundx(ix, nx)
      implicit none
      !-- for input -----------
      integer                     ix, nx
      !-- for output ----------
      integer                     roundx
      !------------------------
      if (ix .ge. 1) then
        roundx = ix - int((ix -1)/nx)*nx
      else
        roundx = nx - abs(mod(ix,nx))
      end if 
      return
      end function roundx
!*****************************************************************
      subroutine ixy2iixy(ix,iy, nx, ny)
      implicit none
      !- for input -----------------
      integer                   ix, iy, nx, ny
      !- for output ----------------
      integer                   iix, iiy,roundx
      !-----------------------------
      if (iy .lt. 1) then
        iiy = 2 - iy
        iix = ix + int(nx/2.0)
        iix = roundx(iix, nx)
      else if (iy .gt. ny) then
        iiy = 2*ny -iy
        iix = ix + int(nx/2.0)
        iix = roundx(iix, nx)
      else
        iiy = iy
        iix = roundx(ix, nx)
      end if
      ix=iix
      iy=iiy 
      return
      end subroutine ixy2iixy
!*****************************************************************  
