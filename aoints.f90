program aoints

  character(len=256) :: ifname
  character(len=256) :: ofname
  integer :: istat
  integer*8 :: fsize

  integer*8 :: max
  integer*8 :: nx
  integer*8, allocatable :: ix(:)
  real*8, allocatable :: xx(:)
  integer*8 :: intcount

  call getarg(1, ifname)

  open(unit=100, file=ifname, status='unknown', access='sequential', form='unformatted', iostat=istat)
  if (istat .ne. 0) then
    print *, 'Could not open file, ', ifname
  end if

  ofname = "./aoints.dat"
  open(unit=102, file=ofname, status='unknown', iostat=istat)

  read (100) max
  max = 15000
  rewind (100)

  intcount = 0
  do
    allocate(xx(max))
    allocate(ix(max / 2))
    read (100, end=300) nx, ix, xx
    print *, nx
    nx = abs(nx)

    do i = 1, nx/2 + 1
      fac = 1.0
      i1 = ibits(ix(i), 56, 8)
      j1 = ibits(ix(i), 48, 8)
      k1 = ibits(ix(i), 40, 8)
      l1 = ibits(ix(i), 32, 8)
      if ((i1 .eq. 0) .or. (j1 .eq. 0) .or. (k1 .eq. 0) .or. (l1 .eq. 0)) cycle
      if (i1 .eq. j1) fac = fac * 2
      if (k1 .eq. l1) fac = fac * 2
      if ((i1 .eq. k1) .and. (j1 .eq. l1)) fac = fac * 2
      print *, xx(2*i-1)
      write (102, 920) i1, j1, k1, l1, xx(2*i-1)*fac
      intcount = intcount + 1

      i2 = ibits(ix(i), 24, 8)
      j2 = ibits(ix(i), 16, 8)
      k2 = ibits(ix(i), 8, 8)
      l2 = ibits(ix(i), 0, 8)
      if ((i2 .eq. 0) .or. (j2 .eq. 0) .or. (k2 .eq. 0) .or. (l2 .eq. 0)) cycle
      fac = 1.0
      if (i2 .eq. j2) fac = fac * 2
      if (k2 .eq. l2) fac = fac * 2
      if ((i2 .eq. k2) .and. (j2 .eq. l2)) fac = fac * 2

      write (102, 920) i2, j2, k2, l2, xx(2*i)*fac
      intcount = intcount + 1

      910 format ('Stored result in file ', A20)
      920 format ('',I5,I5,I5,I5,E25.13)
    end do 
    if (allocated(xx)) deallocate(xx)
    if (allocated(ix)) deallocate(ix)
  end do
  300 continue
  if (allocated(xx)) deallocate(xx)
  if (allocated(ix)) deallocate(ix)
  close(102)
  print *, intcount, ' unique integrals found'

end program aoints