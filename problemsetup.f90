module problemsetup

  use utility, only: fp, maxStrLen

  implicit none
  private

  integer, public :: N
  character(len=maxStrLen), public :: runName, outFile

  public :: problemsetup_Init
  public :: exact_sol
  public :: forcing

contains

  elemental function exact_sol(x) result(sol)
    real(fp), intent(in) :: x
    real(fp) :: sol
    sol = exp(sin(x)) - exp(cos(3*x))
  end function exact_sol

  elemental function forcing(x) result(sol_force)
    real(fp), intent(in) :: x
    real(fp) :: sol_force
    sol_force = exp(sin(x))*(1 + sin(x) - (cos(x))**2) + (exp(cos(3*x))*(9*(sin(3*x))**2 - 9*cos(3*x) - 1))
  end function forcing

  subroutine problemsetup_Init(inFile)
    implicit none
    character(len=*), intent(in) :: inFile

    N = 31

    N = read_initFileInt(inFile, 'num_points')

    write (runName, "('sol_',I0.3)") N
    print *, 'Running problem: ', runName

    outFile = 'data/'//trim(runName)//'.dat'
  end subroutine problemsetup_Init

  function read_initFileInt(inFile, varName) result(varValue)
    character(len=*), intent(in) :: inFile, varName
    integer :: varValue, unit, status
    character(len=256) :: line, key
    logical :: found
    varValue = 0
    found = .false.
    open (newunit=unit, file=inFile, status='old', action='read', iostat=status)
    if (status /= 0) error stop 'Cannot open bvp.init'
    do
      read (unit, '(A)', iostat=status) line
      if (status < 0) exit
      if (status > 0) error stop 'Cannot read bvp.init'
      line = adjustl(line)
      if (len_trim(line) == 0) cycle
      if (line(1:1) == '#') cycle
      read (line, *, iostat=status) key
      if (status /= 0) cycle
      if (trim(key) == varName) then
        read (line, *, iostat=status) key, varValue
        if (status /= 0) error stop 'Invalid num_points value'
        found = .true.
      end if
    end do
    close (unit)
    if (.not. found) error stop 'Missing num_points in bvp.init'
    if (varValue < 3 .or. mod(varValue, 2) == 0) error stop 'num_points must be odd and at least 3'
  end function read_initFileInt
end module problemsetup
