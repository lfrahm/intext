program dict

  integer*8 :: istat

  integer*8 :: fsize
  character(len=256) :: ifname
  character(len=256) :: ofname
  integer*8 :: nrec
  
  integer*8 :: rsize
  integer*8 :: ioda(950)
  integer*8 :: ifilen(950)
  integer*8 :: is
  integer*8 :: ipk
  real*8, allocatable :: xx(:)

  character(len=32) :: irecchars
  integer irec

  CALL getarg(1, ifname)
  CALL getarg(2, irecchars)

  read (irecchars,*) irec

  open(unit=100, file=ifname, status='unknown', access='stream', form='unformatted', iostat=istat)
  if (istat .ne. 0) then
    print *, 'Could not open file'
  end if

  read (100, rec=1) nrec, ioda, ifilen, is, ipk
  nrec = nrec - 1
  write(*, 900) nrec
  900 format ('Expecting ', I3, ' records in given file')

  inquire(unit=100, size=fsize)

  rsize = fsize / nrec
  if (mod( fsize, nrec ) .ne. 0 ) then
    print*, 'Not sure about number of records. File corrupted?'
  end if

  close(unit=100)

  if (ioda(irec) .gt. 0) then
    open(unit=101, file=ifname, status='unknown', access='direct', form='unformatted', iostat=istat, RECL=rsize)

    if (istat .ne. 0) then
      print *, 'Could not open file in direct mode'
    end if
    
    allocate(xx(ifilen(irec)))
    read (101, rec=ioda(irec)) xx

    write(ofname, *) irec
    ofname = "./dict_" // trim(adjustl(ofname)) // ".dat"

    open(unit=102, file=ofname, status='unknown', iostat=istat)
    write(102,*) xx

    close(unit=101)
    close(unit=102)

    write(*, 910) ofname
    910 format ('Stored result in file ', A20)
    
  else
    print *, irec, ' is not in given F10 file.'
  end if

end program dict