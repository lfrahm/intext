program bsp
  integer :: istat

  integer*8 :: max
  integer*8 :: nx
  integer*8, allocatable :: ix(:)
  real*8, allocatable :: xx(:)

  open(unit=100, file="./co_scf.F08", status='unknown', access='sequential', form='unformatted', iostat=istat)

  read (100) max
  max = abs(max)

  rewind (100)

  do k = 1, 2
    allocate(xx(max))
    allocate(ix(max/2))
    read (100) nx, ix, xx
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

      print *, i1, j1, k1, l1, xx(2*i-1)*fac, fac, i

      i2 = ibits(ix(i), 24, 8)
      j2 = ibits(ix(i), 16, 8)
      k2 = ibits(ix(i), 8, 8)
      l2 = ibits(ix(i), 0, 8)
      if ((i2 .eq. 0) .or. (j2 .eq. 0) .or. (k2 .eq. 0) .or. (l2 .eq. 0)) cycle
      fac = 1.0
      if (i2 .eq. j2) fac = fac * 2
      if (k2 .eq. l2) fac = fac * 2
      if ((i2 .eq. k2) .and. (j2 .eq. l2)) fac = fac * 2

      print *, i2, j2, k2, l2, xx(2*i)*fac, fac, i
    end do 
  if (allocated(xx)) deallocate(xx)
  if (allocated(ix)) deallocate(ix)
  end do

end program bsp