      program prog_i1l2xy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare l2x and l2y files
cby   2010/09/30, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
c parameter (default)
      integer           n0of
      parameter        (n0of=16) 
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c temporary
      character*128     c0tmp
c function
      integer           iargc
c out
      real,allocatable::r1l2x(:)
      real,allocatable::r1l2y(:)
      character*128     c0l2x
      character*128     c0l2y
c local
      character*128     c0l
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.5)then
        write(*,*) 'Usage: htl2xl2y n0l n0x n0y c0l2x c0l2y'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y
      call getarg(4,c0l2x)
      call getarg(5,c0l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1l2x(n0l))
      allocate(r1l2y(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0l=1
      do i0y=1,n0y
        do i0x=1,n0x
          r1l2x(i0l)=real(i0x)
          r1l2y(i0l)=real(i0y)
          i0l=i0l+1
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(c0l,*) n0l
c 
      open(n0of,file=c0l2x)
      write(n0of,'('//c0l//'f8.0)') (r1l2x(i0l),i0l=1,n0l)
      close(n0of)
c
      open(n0of,file=c0l2y)
      write(n0of,'('//c0l//'f8.0)') (r1l2y(i0l),i0l=1,n0l)
      close(n0of)
c
      end
