program bvp
  use utility, only: fp, pi
  use dft, only: matvecprod, dft_InvTransMat, dft_TransMat
  use problemsetup, only: N, outFile, exact_sol, forcing, problemsetup_Init

  implicit none

  real(fp) :: dx
  real(fp), allocatable :: x(:), k(:)
  real(fp), allocatable :: u(:), f(:), ft(:)
  real(fp), allocatable :: T(:, :), Tinv(:, :)
  integer :: i, status

  print "(' Selected real kind: fp = ',i2)", fp

  call problemsetup_Init('bvp.init')

  allocate (x(N), k(N), u(N), f(N), ft(N), T(N, N), Tinv(N, N))

  dx = (2.0_fp*pi)/N
  do i = 1, N
    x(i) = (i - 1)*dx
  end do
  f = forcing(x)

  call dft_TransMat(x, k, T)

  call dft_InvTransMat(x, k, Tinv)

  ft = matvecprod(T, f)

  ! The Fourier symbol of (1 - d²/dx²) is 1 + k².
  ft = ft/(1 + k**2)

  u = matvecprod(Tinv, ft)
  print *, "Err: ", calculate_error()

  call write_data()

  deallocate (x, k, u, f, ft, T, Tinv)

contains

  function calculate_error() result(err)
    implicit none
    real(fp) :: err
    err = maxval(abs(u - exact_sol(x)))
  end function calculate_error

  subroutine write_data()
    implicit none
    print *, 'Writing file: ', outFile
    call execute_command_line('mkdir -p data', exitstat=status)
    if (status /= 0) error stop 'Cannot create data directory'
    open (20, file=outFile, status="replace", iostat=status)
    if (status /= 0) error stop 'Cannot open solution output'
    do i = 1, N
      write (20, *) x(i), u(i), f(i), ft(i)
    end do
    close (20)
  end subroutine write_data

end program bvp
