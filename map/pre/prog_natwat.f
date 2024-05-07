      program prog_natwat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   estimate 'national waters'
cby   2016/05/27, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0l
      integer           n0x
      integer           n0y
      parameter        (n0l=9331200) 
      parameter        (n0x=4320)
      parameter        (n0y=2160)
c index
      integer           i0l
      integer           i0x
      integer           i0y
c function
      integer           igetnxx
      integer           igetnxy
c in
      real              r1natmsk(n0l)
      character*128     c0natmsk
      integer           i1l2x(n0l)
      integer           i1l2y(n0l)
      character*128     c0l2x
      character*128     c0l2y
c out
      real              r1natwat(n0l)
      character*128     c0natwat
c local 
      integer           i0f           !! flow direction
      integer           i0flg         !! a flag
      integer           i1x(n0l)      !! X coord0nate
      integer           i1y(n0l)      !! Y coord0nate
      integer           i1l(n0l)      !! L coord0nate
      real              r0natmsk      !! temporary
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.4)then
        write(*,*) 'prog_natwat l2x l2y c0natmsk c0natwat'
        stop
      end if
c
      call getarg(1,c0l2x)
      call getarg(2,c0l2y)
      call getarg(3,c0natmsk)
      call getarg(4,c0natwat)
c
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read/calc/write
c
c  Caution: simplistic algorithm
c  Priority is given for countries locating west/north 
c  compared with east/south.
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0natmsk,r1natmsk)
c
      do i0l=1,n0l
        i0x=i1l2x(i0l)
        i0y=i1l2y(i0l)
C        write(*,*) i0x, i0y 
        if(r1natmsk(i0l).eq.0)then
          do i0f=1,8
c
            i1x(i0f)=igetnxx(n0x,i0x,i0f)
            if (i1x(i0f).gt.n0x)then
              i1x(i0f)=1
            else if (i1x(i0f).lt.1)then
              i1x(i0f)=n0x
            end if
c
            i1y(i0f)=igetnxy(n0y,i0y,i0f)
            if (i1y(i0f).gt.n0y)then
              i1y(i0f)=n0y
            else if (i1y(i0f).lt.1)then
              i1y(i0f)=1
            end if
c
            i1l(i0f)=i1x(i0f)+n0x*(i1y(i0f)-1)
            if (i1l(i0f).gt.n0l)then
              write(*,*) i1x(i0f),i1y(i0f),i1l(i0f),i0l,i0f
              stop
            end if
c
C          write(*,*) i1x(i0f),i1y(i0f),i1l(i0f),i0l,i0f,i0x,i0y
          end do
          i0flg=0
c
          r0natmsk=r1natmsk(i1l(3))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'3',i1l(3),r0natmsk
c
          r0natmsk=r1natmsk(i1l(7))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'7',i1l(7),r0natmsk
c
          r0natmsk=r1natmsk(i1l(1))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'1',i1l(1),r0natmsk
c
          r0natmsk=r1natmsk(i1l(5))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'5',i1l(5),r0natmsk
c
          r0natmsk=r1natmsk(i1l(2))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'2',i1l(2),r0natmsk
c
          r0natmsk=r1natmsk(i1l(8))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'8',i1l(8),r0natmsk
c
          r0natmsk=r1natmsk(i1l(4))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'4',i1l(4),r0natmsk
c
          r0natmsk=r1natmsk(i1l(6))
          if(i0flg.eq.0.and.r0natmsk.gt.0)then
            r1natwat(i0l)=r0natmsk
            i0flg=1
          end if
ccc          write(*,*) i0l,'6',i1l(6),r0natmsk
        end if
      end do
c
      call wrte_binary(n0l,r1natwat,c0natwat)
c
      end
