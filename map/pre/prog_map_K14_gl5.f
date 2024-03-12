      program prog_K14_gl5
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert canal data format
cby   2016/02/01, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      integer           n0rec         !! # of cells to deliver water of implicit
      integer           n0recout      !! to output
      integer           n0ord         !! number of origin grid to one destination grid
      real              p0mis         !! missing value
      parameter        (n0l=9331200)
      parameter        (n0rec=120)
      parameter        (n0recout=120)
      parameter        (n0ord=2)
      parameter        (p0mis=1.0E20)
c index
      integer           i0l
      integer           i0rec
      integer           i0ord
c temporary
      integer           i0tmp
      real              r1tmp(n0l)
c in
      real              r2in(n0l,n0ord)            !! original canal file TITECH
c      real              r2out(n0l,n0ord)           !! original canal file TITECH
      real              r1out(n0l)                 !! original canal file TITECH
      real              r1lautorg(n0l)             !! automatic generated origin 
      real              r2lautdes(n0l,n0rec)       !! automatic generated destin
      real              r1seq(n0l)                 !! river sequence
      character*128     c0in
      character*128     c0out
      character*128     c0lautorg
      character*128     c0lautdes
      character*128     c0seq
c out
      real              r2lcanorg(n0l,n0ord)       !! converted canal file
      real              r2lcandes(n0l,n0recout)    !! converted canal file
      real              r2lmrgorg(n0l,n0ord)       !! merged origin 
      real              r2lmrgdes(n0l,n0recout)    !! merged destication
      real              r2catorg(n0l,n0ord)
      real              r2catdes(n0l,n0recout)
      character*128     c0lcanorg
      character*128     c0lcandes
      character*128     c0lmrgorg
      character*128     c0lmrgdes
      character*128     c0catorg
      character*128     c0catdes
c
      integer           i0id
      integer           i0lcanorg
      integer           i1cnt(n0recout)
      integer           i0cntok
      integer           i0cntng
      integer           i1id2l(n0l)                 !! converter id --> l
      integer           i1id2seq(n0l)               !! converter id --> sequence
      integer           i0ldbg
      data              i0ldbg/20756/
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.9)then
        write(*,*) 'prog_K14 c0in c0out c0lautorg c0lautdes c0seq'
        write(*,*) 'c0lcanorg  c0lcandes c0lmrgorg c0lmrgdes'
        stop
      end if
c
      call getarg(1,c0in)
      call getarg(2,c0out)
      call getarg(3,c0lautorg)
      call getarg(4,c0lautdes)
      call getarg(5,c0seq)
      call getarg(6,c0lcanorg)
      call getarg(7,c0lcandes)
      call getarg(8,c0lmrgorg)
      call getarg(9,c0lmrgdes)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0out,    r1out)
      call read_binary(n0l,c0seq,    r1seq)
      call read_binary(n0l,c0lautorg,r1lautorg)
c
      open(15,file=c0in,access='DIRECT',recl=n0l*4)
      do i0ord=1,n0ord
        read(15,rec=i0ord)(r1tmp(i0l),i0l=1,n0l)
        do i0l=1,n0l
          r2in(i0l,i0ord)=r1tmp(i0l)
        end do
      end do
      close(15)

      write(*,*) c0lautdes
      open(15,file=c0lautdes,access='DIRECT',recl=n0l*4)
c      do i0rec=1,n0rec
      do i0rec=1,n0rec
        read(15,rec=i0rec)(r1tmp(i0l),i0l=1,n0l)
        do i0l=1,n0l
          r2lautdes(i0l,i0rec)=r1tmp(i0l)
        end do
      end do
      close(15)
c
      write(*,*) 'r2in',r2in(i0ldbg,1)
      write(*,*) r1out(i0ldbg)
      write(*,*) r1lautorg(i0ldbg)
      write(*,*) r2lautdes(i0ldbg,1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c make look up table
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1out(i0l).ne.p0mis)then
          i0id=int(r1out(i0l))
          if(i0id.ne.0)then
            i1id2l(i0id)=i0l
            i1id2seq(i0id)=int(r1seq(i0l))
            write(*,*) i1id2l(i0id),i1id2seq(i0id)
          end if
        end if
      end do

c
c      write(*,*) 'i1id2l',i1id2l(int(r2out(i0ldbg),1),1)
c      write(*,*) i1id2seq(int(r2out(i0ldbg,1)),1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c convert
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0ord=1,n0ord
        do i0l=1,n0l
          if(r2in(i0l,i0ord).ne.p0mis)then
            r2lcanorg(i0l,i0ord)
     $         =real(i1id2l(int(r2in(i0l,i0ord))))
          end if
        end do
      end do
c
      i0cntok=0
      i0cntng=0
      do i0rec=1,n0recout
        do i0l=1,n0l
          do i0ord=1,n0ord
            if(r2in(i0l,i0ord).ne.0.0.and.r2in(i0l,i0ord).ne.p0mis)then
              i0lcanorg=i1id2l(int(r2in(i0l,i0ord)))
              if(r2lcandes(i0lcanorg,i0rec).eq.0.0)then
                if(i0lcanorg.eq.0)then
                  write(*,*) '--'
                else
                  if(int(r1seq(i0l)).lt.r1seq(i0lcanorg))then
                    write(*,*) 'ok',i0l   ,int(r1seq(i0l)),
     $                   'from ',i0lcanorg,int(r1seq(i0lcanorg)),
     $                   'canal ',int(r2in(i0l,i0ord))
                    r2lcandes(i0lcanorg,i0rec)=real(i0l)
                    i0cntok=i0cntok+1
                  else
                    write(*,*) 'ng',i0l   ,int(r1seq(i0l)),
     $                   'from ',i0lcanorg,int(r1seq(i0lcanorg)),
     $                   'canal ',int(r2in(i0l,i0ord))
                    r2lcanorg(i0l,i0ord)=0.0
                    i0cntng=i0cntng+1
                  end if
                  i1cnt(i0rec)=i1cnt(i0rec)+1
                end if
                r2in(i0l,i0ord)=0.0
              end if
            end if
          end do
        end do
      end do
c
      do i0rec=1,n0recout
        write(*,*) 'distance: ',i0rec,'num of can: ',i1cnt(i0rec)
      end do
      write(*,*) i0cntok
      write(*,*) i0cntng
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c merge
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        do i0ord=1,n0ord
          if(r2lcanorg(i0l,i0ord).ne.0)then
            r2lmrgorg(i0l,i0ord)=r2lcanorg(i0l,i0ord)
            r2catorg(i0l,i0ord)=1.0
          end if
        end do
      end do
c
      do i0l=1,n0l
        do i0ord=1,n0ord
          if(r2lcanorg(i0l,i0ord).eq.0.and.r1lautorg(i0l).ne.0)then
            r2lmrgorg(i0l,i0ord)=r1lautorg(i0l)
            r2catorg(i0l,i0ord)=2.0
            r1lautorg(i0l)=0.0
          end if
        end do
      end do
c
      r2lmrgdes=0.0 !! change
      do i0l=1,n0l
        do i0rec=1,n0recout
          if(r2lcandes(i0l,i0rec).ne.0)then
            r2lmrgdes(i0l,i0rec)=r2lcandes(i0l,i0rec)
            r2catdes(i0l,i0rec)=1.0
          end if
        end do
      end do
c !! change
      do i0l=1,n0l    
     
        do i0rec=1,n0rec
          if(r2lmrgdes(i0l,i0rec).eq.0)then
               
            do i0tmp=1,n0rec
              if(i0rec+i0tmp-1.le.n0recout)then
                if(r2lautdes(i0l,i0tmp).ne.0)then
                   r2lmrgdes(i0l,i0rec+i0tmp-1)=r2lautdes(i0l,i0tmp)
                   r2catdes(i0l,i0rec+i0tmp-1)=2.0
                end if
              end if
            end do
            exit
            
          end if
        end do
       
      end do


      write(*,*) 'r2lcanorg',r2lcanorg(i0ldbg,1)
      write(*,*) 'r2lmrgorg',r2lmrgorg(i0ldbg,1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(16,file=c0lcanorg,access='DIRECT',recl=n0l*4)
      do i0ord=1,n0ord
        do i0l=1,n0l
          r1tmp(i0l)=r2lcanorg(i0l,i0ord)
        end do
        write(16,rec=i0ord)(r1tmp(i0l),i0l=1,n0l)
      end do
      close(16)
c
      open(16,file=c0lcandes,access='DIRECT',recl=n0l*4)
      do i0rec=1,n0recout
        do i0l=1,n0l
          r1tmp(i0l)=r2lcandes(i0l,i0rec)
        end do
        write(16,rec=i0rec)(r1tmp(i0l),i0l=1,n0l)
      end do
      close(16)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(16,file=c0lmrgorg,access='DIRECT',recl=n0l*4)
      do i0ord=1,n0ord
        do i0l=1,n0l
          r1tmp(i0l)=r2lmrgorg(i0l,i0ord)
        end do
        write(16,rec=i0ord)(r1tmp(i0l),i0l=1,n0l)
      end do
      close(16)
c
      open(16,file=c0lmrgdes,access='DIRECT',recl=n0l*4)
      do i0rec=1,n0recout
        do i0l=1,n0l
          r1tmp(i0l)=r2lmrgdes(i0l,i0rec)
        end do
        write(16,rec=i0rec)(r1tmp(i0l),i0l=1,n0l)
      end do
      close(16)
c
      end
